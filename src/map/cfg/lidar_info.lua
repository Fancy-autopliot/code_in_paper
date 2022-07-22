-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,                    
  trajectory_builder = TRAJECTORY_BUILDER,      --
  map_frame = "map",                            --一般为“map”.用来发布submap的ROS帧ID.
  tracking_frame = "base_link",                 --SLAM算法要跟踪的ROS 帧ID
	published_frame = "base_link",                --用来发布pose的帧ID
  odom_frame = "odom",                          --只要当有里程计信息的时候才会使用。即provide_odom_frame=true
  provide_odom_frame = true,                    --如果为true，the local, non-loop-closed, continuous pose将会在map_frame里以odom_frame发布
  publish_frame_projected_to_2d = false,        --如果为true，则已经发布的pose将会被完全成２D的pose，没有roll,pitch或者z-offset
  use_odometry = false,                         --如果为true，需要提供里程计信息，并话题/odom会订阅nav_msgs/Odometry类型的消息，在SLAM过程中也会使用这个消息进行建图
  use_nav_sat = false,                          --如果为true，会在话题/fix上订阅sensor_msgs/NavSatFix类型的消息，并且在globalSLAM中会用到
  use_landmarks = false,                        --如果为true，会在话题/landmarks上订阅cartographer_ros_msgs/LandmarkList类型的消息，并且在SLAM过程中会用到
  num_laser_scans = 1,                          --SLAM可以输入的/scan话题数目的最大值
  num_multi_echo_laser_scans = 0,               --SLAM可以输入sensor_msgs/MultiEchoLaserScan话题数目的最大值
  num_subdivisions_per_laser_scan = 1,          --将每个接收到的（multi_echo）激光scan分割成的点云数。 细分scam可以在扫描仪移动时取消scanner获取的scan。 
                                                --有一个相应的trajectory builder option可将细分扫描累积到将用于scan_matching的点云中
  num_point_clouds = 0,                         --SLAM可以输入的sensor_msgs/PointCloud2话题数目的最大值
  lookup_transform_timeout_sec = 0.2,           --使用tf2查找transform的超时时间（秒）
  submap_publish_period_sec = 0.3,              --发布submap的时间间隔（秒）
  pose_publish_period_sec = 5e-3,               --发布pose的时间间隔，值为5e-3的时候为200HZ
  trajectory_publish_period_sec = 30e-3,        --发布trajectory markers（trajectory的节点）的时间间隔，值为30e-3为30ms
  rangefinder_sampling_ratio = 1.,              --测距仪的固定采样ratio
  odometry_sampling_ratio = 0.1,                --里程计的固定采样ratio
  fixed_frame_pose_sampling_ratio = 1.,         --****采样频率
  imu_sampling_ratio = 1.,                      --IMU message的固定采样ratio
  landmarks_sampling_ratio = 1.,                --landmarks message的固定采样ratio
}   

MAP_BUILDER.use_trajectory_builder_2d = true

TRAJECTORY_BUILDER_2D.submaps.num_range_data = 35     
TRAJECTORY_BUILDER_2D.min_range = 0.3
TRAJECTORY_BUILDER_2D.max_range = 8.
TRAJECTORY_BUILDER_2D.missing_data_ray_length = 1.
TRAJECTORY_BUILDER_2D.use_imu_data = false
TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching = true
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window = 0.1
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.translation_delta_cost_weight = 10.
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.rotation_delta_cost_weight = 1e-1

POSE_GRAPH.optimization_problem.huber_scale = 1e2
POSE_GRAPH.optimize_every_n_nodes = 35
POSE_GRAPH.constraint_builder.min_score = 0.65

return options
