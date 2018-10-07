import sys
import rosbag
import time
import subprocess
import yaml
import rospy
import os
import argparse
import math
from shutil import move

def status(length, percent):
  sys.stdout.write('\x1B[2K') # Erase entire current line
  sys.stdout.write('\x1B[0E') # Move to the beginning of the current line
  progress = "Progress: ["
  for i in range(0, length):
    if i < length * percent:
      progress += '='
    else:
      progress += ' '
  progress += "] " + str(round(percent * 100.0, 2)) + "%"
  sys.stdout.write(progress)
  sys.stdout.flush()


def change_header(msg, stamp):
    for tran in msg.transforms:
        tran.header.stamp = stamp

def main(args):
  parser = argparse.ArgumentParser(description='Reorder a bagfile based on header timestamps.')
  parser.add_argument('bagfile', nargs=1, help='input bag file')
  parser.add_argument('--max-offset', nargs=1, help='max time offset (sec) to correct.', default='60', type=float)
  args = parser.parse_args()
    
  # Get bag duration  
  
  bagfile = args.bagfile[0]
  
  info_dict = yaml.load(subprocess.Popen(['rosbag', 'info', '--yaml', bagfile], stdout=subprocess.PIPE).communicate()[0])
  duration = info_dict['duration']
  start_time = info_dict['start']
  end_time = info_dict['end']

  orig = bagfile
  outbagfile = os.path.splitext(bagfile)[0] + ".out.bag"
  
#   move(bagfile, orig)

  static_transforms = []
  static_transform_publish_period = 0.1

  for topic, msg, t in rosbag.Bag(orig).read_messages():
      if topic == "/tf_static" and msg.transforms:
        static_transforms.append(msg)

  with rosbag.Bag(outbagfile, 'w') as outbag:
    last_time = time.clock()

    cur_time = start_time
    while cur_time < end_time:
        cur_time += static_transform_publish_period
        cur_time_ros = rospy.Time.from_sec(cur_time)
        if static_transforms:
            for trans in static_transforms:
                change_header(trans, cur_time_ros)
                outbag.write('/tf', trans, cur_time_ros)

    for topic, msg, t in rosbag.Bag(orig).read_messages():
      if time.clock() - last_time > .1:
          percent = (t.to_sec() - start_time) / duration
          status(40, percent)
          last_time = time.clock()
      # This also replaces tf timestamps under the assumption 
      # that all transforms in the message share the same timestamp
      if topic == "/tf_static":
        pass
      else:
          outbag.write(topic, msg, t)
  status(40, 1)
  print "\ndone"

if __name__ == "__main__":
  main(sys.argv[1:])