#x9!/bin/bash

Usage=$(cat <<EOF
Run kubectl Commands, Push Files, Pull Files Test Cases

Usage:
  Test:
     2: Create eBPF Root kit
     3: Create Head Crab Root kit
     4: Create Diamorphine Demo
     5: Running container with hostMount /var/run/docker.sock
    13: Running container connecting outboud connection to kurtisvelarde.com
    29: Running container create /bin/kdate and execute Drift
    30: Running container and nmaping it
    31: Running container /bin/id and execute
    56: Running container create /bin/kdate and execute
    63: Running ReadOnly FS
    69: Running container with resources block
    71: Running container AppArmor Profile Set
    73: Running Security Privlaged
    74: Running Volume Mounts
    76: Running hostIPC 
    83: Running hostPID
    96: Running with CAP_SYS_ADMIN
EOF)

case "$1" in
    83)
	echo -e "[!] Running hostPID #83."
        kubectl apply -k overlays/hostPID/
        kubectl delete -k overlays/hostPID/
        ;;
    71)
	echo -e "[!] Running With AppArmor Profile Set."
        kubectl apply -k overlays/appArmor/
        kubectl delete -k overlays/appArmor/
        ;;
    69)
	echo -e "[!] Running with cpu/mem resources #1."
        kubectl apply -k overlays/resources/
        kubectl delete -k overlays/resources/
        ;;
    2)
	echo -e "[!] Create eBPF Root kit #2."
        kubectl apply -k overlays/bpf_rootkit/
        kubectl delete -k overlays/bpf_rootkit/
        ;;
    3)
	echo -e "[!] Create Head Crab Root kit #3."
        kubectl apply -k overlays/headCrab/
	sleep 360
        kubectl delete -k overlays/headCrab/
        ;;
    4)
	echo -e "[!] Create diamorphine."
        kubectl apply -k overlays/diamorphine/
	sleep 360
        kubectl delete -k overlays/diamorphine/
        ;;
    5)
	echo -e "[!] Volume Mount Docker Socket."
        kubectl apply -k overlays/mountDockerSock/
        kubectl delete -k overlays/mountDockerSock/
        ;;
    63)
	echo -e "[!] Running ReadOnly FS #63."
        kubectl apply -k overlays/readOnlyFs/
        kubectl delete -k overlays/readOnlyFs/
        ;;
    96)
	echo -e "[!] Running with CAP_SYS_ADMIN #96."
        kubectl apply -k overlays/capSysADMIN/
        kubectl delete -k overlays/capSysADMIN/
        ;;
    2)
	echo -e "[!] Running hostNetwork #2."
        kubectl apply -k overlays/hostNetwork/
        kubectl delete -k overlays/hostNetwork/
     
        ;;
    76)
	echo -e "[!] Running hostIPC #3."
        kubectl apply -k overlays/hostIPC/
        kubectl delete -k overlays/hostIPC/
        ;;
    74)
	echo -e "[!] Running Volume Mounts #4."
        kubectl apply -k overlays/volumeMounts/
        kubectl delete -k overlays/volumeMounts/
        ;;
    5)
	echo -e "[!] Running Security Context RunAsUser #5."
        kubectl apply -k overlays/secContextRunAs/
        kubectl delete -k overlays/secContextRunAs/
        ;;
    73)
	echo -e "[!] Running Security Privlaged #5."
        kubectl apply -k overlays/priv/
        kubectl delete -k overlays/priv/
        ;;
    13)
	echo -e "[!] Running container connecting outboud connection to kurtisvelarde.com #13."
	kubectl run -it mypod --image=nginx -- /bin/sh -c "curl https://kurtisvelarde.com"
        kubectl delete pod mypod
        ;;
    29)
	echo -e "[!] Running container create /bin/kdate and execute (drift) #29."
	kubectl run -it mypod --image=nginx -- /bin/bash -c "cp /bin/{date,kdate} && /bin/kdate"
        kubectl delete pod mypod
        ;;
    30)
	echo -e "[!] Running container and nmaping it #30."
        kubectl create deployment nginx --image=nginx:latest
        bpod_ip=$(kubectl get pods -lapp=nginx -o jsonpath='{.items[*].status.podIP}')
	# kubectl run -it mypod --image=alpine -- /bin/bash -c "ping -c 2 ${bpod_ip}"
        kubectl run -it mypod --image=alpine -- /bin/sh -c "nc -w 2 -z -v ${bpod_ip} 80"
        kubectl delete pod mypod
        kubectl delete deployment nginx
        ;;
    31)
	echo -e "[!] Running container /bin/id and execute #31."
	kubectl run -it mypod --rm=True --image=nginx -- /bin/bash -c "id"
        kubectl delete pod mypod
        ;;
    56)
	echo -e "[!] Running container create /bin/kdate and execute #56."
	kubectl run --rm -it mypod --image=nginx -- /bin/bash -c "head -n10 /etc/shadow"
        ;;
    *)
        echo "$Usage"
        ;;
esac
