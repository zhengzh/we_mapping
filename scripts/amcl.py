#!/usr/bin/env python

import sys
import rospy
from std_srvs.srv import EmptyRequest
from geometry_msgs.msg import PoseWithCovarianceStamped

try:
    global_localizaion = rospy.ServiceProxy('global_localization', EmptyRequest)
    request_nomotion_update = rospy.ServiceProxy('request_nomotion_update', EmptyRequest)
    
    global_localizaion()
except rospy.ServiceException, e:
        print "Service call failed: %s"%e


initial_pose_pub = rospy.Publisher('initial_pose', PoseWithCovarianceStamped, queue_size=10)


def test():
    p = PoseWithCovarianceStamped()
    p.header.frame_id = "map"
    p.pose.pose.position.x = self.pose[0]
    p.pose.pose.position.y = self.pose[1]
    (p.pose.pose.orientation.x,
        p.pose.pose.orientation.y,
        p.pose.pose.orientation.z,
        p.pose.pose.orientation.w) = transformations.quaternion_from_euler(0, 0, self.pose[2])
    # independent
    p.pose.covariance[6*0+0] = 0.5 * 0.5
    p.pose.covariance[6*1+1] = 0.5 * 0.5
    p.pose.covariance[6*3+3] = math.pi/12.0 * math.pi/12.0

    initial_pose_pub.publish(p)
    
if __name__ == "__main__":
    if len(sys.argv) == 3:
        x = int(sys.argv[1])
        y = int(sys.argv[2])
    else:
        print usage()
        sys.exit(1)
    print "Requesting %s+%s"%(x, y)
    print "%s + %s = %s"%(x, y, add_two_ints_client(x, y))