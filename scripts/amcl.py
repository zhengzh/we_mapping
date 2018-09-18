#!/usr/bin/env python

import sys
import rospy
from std_srvs.srv import Empty
from geometry_msgs.msg import PoseWithCovarianceStamped
from tf import transformations
import math

class AMCL:
    def __init__(self):
        rospy.wait_for_service('global_localization', 1)
        try:
            self.global_localizaion = rospy.ServiceProxy('global_localization', Empty)
            self.request_nomotion_update = rospy.ServiceProxy('request_nomotion_update', Empty)
        except rospy.ServiceException, e:
                print "Service call failed: %s"%e

        self.initial_pose_pub = rospy.Publisher('initial_pose', PoseWithCovarianceStamped, queue_size=10)

    def publish_initial_pose(self, pose):
        p = PoseWithCovarianceStamped()
        p.header.frame_id = "map"
        p.pose.pose.position.x = pose[0]
        p.pose.pose.position.y = pose[1]
        (p.pose.pose.orientation.x,
            p.pose.pose.orientation.y,
            p.pose.pose.orientation.z,
            p.pose.pose.orientation.w) = transformations.quaternion_from_euler(0, 0, pose[2])
        p.pose.covariance[6*0+0] = 0.5 * 0.5
        p.pose.covariance[6*1+1] = 0.5 * 0.5
        p.pose.covariance[6*3+3] = math.pi/12.0 * math.pi/12.0
        self.initial_pose_pub.publish(p)

def test():
    rospy.init_node("test_amcl", anonymous=True)
    amcl = AMCL()
    amcl.global_localizaion()
    amcl.request_nomotion_update()
    amcl.publish_initial_pose([0,0,0])
    # initial_pose_pub.publish(p)
    
if __name__ == "__main__":
    test()