function vel=setVelocity(ClientID,speed,motor_handle,vrep)
vel=speed;
[~]=vrep.simxSetJointTargetVelocity(ClientID,motor_handle,speed,vrep.simx_opmode_blocking);


