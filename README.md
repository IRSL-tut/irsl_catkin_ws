# irsl_catkin_ws

# Uss docker packages { docker or local install(optional) }

- irsl_catkin_ws/src 以下にレポジトリ(pkg)を配置

- レポジトリ(pkg)の作り方のサンプルは https://github.com/IRSL-tut/irsl_docker_pkg_sample

- ローカルのsupervisorによって 起動/停止ができるように ( https://github.com/IRSL-tut/irsl_catkin_ws/issues/3 )

## レポジトリ(pkg)の要点

### dockerで動かすとき
```
roslaunch <pkg_name> run_docker.launch
```

```
(optional)
rosrun <pkg_name> run_docker.sh
```

このとき、ROS_MASTER_URI / ROS_IP / ROS_HOSTNAME が 上げたいROS環境に対して適切に設定されるように

( NAMESPACEなんかもあったほうがよいかも )

### localで動かすとき
```
roslaunch <pkg_name> run.launch
```

```
(optional)
rosrun <pkg_name> run.sh
```
