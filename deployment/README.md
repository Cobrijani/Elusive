# Instruction regarding to docker


1. Increase max virtual memory
```
docker-machine ls
docker-machine ssh <docker-machine-name>
sudo sysctl -w vm.max_map_count=262144
```
2. Increase RAM memory for virtualbox atleast 3GB

