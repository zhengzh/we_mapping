include "urg_lidar_2d.lua"

TRAJECTORY_BUILDER.pure_localization_trimmer = {
  max_submaps_to_keep = 3,
}
MAP_BUILDER.num_background_threads = 8
POSE_GRAPH.optimize_every_n_nodes = 1
-- POSE_GRAPH.constraint_builder.sampling_ratio = 0.1
POSE_GRAPH.constraint_builder.sampling_ratio = 0.005 * POSE_GRAPH.constraint_builder.sampling_ratio
-- POSE_GRAPH.global_sampling_ratio = 0.001
POSE_GRAPH.global_sampling_ratio = 0.005 * POSE_GRAPH.global_sampling_ratio
-- POSE_GRAPH.constraint_builder.min_score = 1.5 * POSE_GRAPH.constraint_builder.min_score
POSE_GRAPH.max_num_final_iterations = 1
TRAJECTORY_BUILDER_2D.num_accumulated_range_data = 10
-- POSE_GRAPH.optimization_problem.log_solver_summary = true
TRAJECTORY_BUILDER_2D.submaps.num_range_data = 30
POSE_GRAPH.constraint_builder.min_score = 0.8
POSE_GRAPH.global_constraint_search_after_n_seconds = 20.
-- options.rangefinder_sampling_ratio = 0.4
return options
