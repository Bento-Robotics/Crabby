import os
import yaml

from launch import LaunchDescription
from launch_ros.actions import Node

from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration

from launch.actions import GroupAction
from launch_ros.actions import PushRosNamespace

from launch.substitutions import EnvironmentVariable, PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():

    robot_namespace = LaunchConfiguration('robot_namespace')

    evotrainer_drive = Node(
        package='evotrainer_drive',
        executable='evotrainer_drive_node',
        name='evotrainer_drive_node',
        parameters=[ PathJoinSubstitution([ '/', 'launch-content', 'parameters', 'crabby.yaml' ]) ],
        #remappings=[('odom', '/odom' ), ('pose', '/pose')],
        output='screen',
	emulate_tty=True,
    )

    joystick = Node(
        package='joy_linux',
        executable='joy_linux_node',
    )

    camera_ros = Node(
        package='camera_ros',
        executable='camera_node',
        name='camera_node',
        parameters=[ PathJoinSubstitution([ '/', 'launch-content', 'parameters', 'camera_ros.yaml' ]) ],
        namespace="cam",
        emulate_tty=True,
    )

    lidar = Node(
        name='rplidar_composition',
        package='rplidar_ros',
        executable='rplidar_composition',
        output='screen',
        emulate_tty=True,
        parameters=[{
            'serial_port': '/dev/ttyUSB0',
            'serial_baudrate': 115200,  # A1 / A2
            # 'serial_baudrate': 256000, # A3
            'frame_id': 'laser',
            'inverted': False,
            'angle_compensate': True,
        }],
    )

    tf2_node = Node(
        package='tf2_ros',
        executable='static_transform_publisher',
        name='base_link_to_base_tof',
        arguments=["--x", "0.0","--y", "0.0","--z", "0.1","--roll", "0.0","--pitch", "0.0","--yaw", "0.0",
        #TODO add values
        "--frame-id", "base_link","--child-frame-id", "laser"],
        output="screen"
    )

    return LaunchDescription([
        DeclareLaunchArgument(
            'robot_namespace',
            default_value='bento',
            description='set namespace for robot nodes'
        ),
        GroupAction(
        actions=[
            PushRosNamespace(robot_namespace),
            joystick,
            camera_ros,
            evotrainer_drive,
            #lidar,
        ]),
        #lidar,
        #tf2_node
    ])
