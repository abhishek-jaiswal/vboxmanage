#!/usr/bin/env bash

vm_create(){
    # local variable x and y with passed args
    VM=$1
    MEMORY=2048
    VRAM=64
    TYPE='Linux_64'

   if [ $VM == "controller" ]
    then
        ssh_port=2221
    elif [ $VM == "compute" ]
    then
        ssh_port=2222
    elif [ $VM == "network" ]
    then
       ssh_port=2223

    else
        ssh_port=2220
    fi


    VBoxManage createvm -name $VM -register

    #VBoxManage modifyvm $VM --memory $MEMORY --vram $VRAM --acpi on --boot1 dvd --nic1 nat --nic2 bridged --bridgeadapter1 eth0

    VBoxManage modifyvm $VM --memory $MEMORY --vram $VRAM --acpi on --boot1 dvd --nic1 nat
    #VBoxManage modifyvm $vm --nic2 bridged --bridgeadapter1 eth0

    VBoxManage modifyvm $VM --ostype $TYPE

    VBoxManage createvdi --filename $VM.vdi --size 40960

    VBoxManage storagectl $VM --name "IDE Controller" --add ide

    VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium iso/autoinstall_ubuntu_base.iso

    VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
    VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi


    #VBoxManage storagectl $VM --name "IDE Controller" --add ide
    #VBoxManage modifyvm $VM --boot1 dvd --hda $VM.vdi --sata on

    # port forwarding
    VBoxManage modifyvm $VM --natpf1 "guestssh,tcp,,$ssh_port,,22"

    VBoxManage startvm $VM
}

#for name in controller compute network
for name in controller
do
    vm_create $name
done
