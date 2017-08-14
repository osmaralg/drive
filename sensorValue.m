function d=sensorValue(clientID,sensor_handle,vrep)
[~,~,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,sensor_handle,vrep.simx_opmode_buffer);
d=norm(detectedPoint);