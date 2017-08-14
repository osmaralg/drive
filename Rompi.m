% Por favor guardar un copia del archivo original en caso de modificación
% Ver el siguiente video https://www.youtube.com/watch?v=piI5wYEXUms
clc 
clear all 
close all
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m) Crear una conección remota
vrep.simxFinish(-1); % just in case, close all opened connections 
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5); % Conectar en localhost, puerto 19999 espeficado en script

 if (clientID>-1) % Si la coneccion fue exitosa
        disp('Connected to remote API server');
        %% Handle es el numero que sirve para modificar un objecto. 
        [~,left_front]=vrep.simxGetObjectHandle(clientID,'front_left_motr',vrep.simx_opmode_blocking); 
        [~,right_front]=vrep.simxGetObjectHandle(clientID,'front_right_motor',vrep.simx_opmode_blocking);
        [~,left_back]=vrep.simxGetObjectHandle(clientID,'back_left_motor',vrep.simx_opmode_blocking);
        [~,right_back]=vrep.simxGetObjectHandle(clientID,'back_right_motor',vrep.simx_opmode_blocking);
        [~,front_Sensor]=vrep.simxGetObjectHandle(clientID,'Proximity_sensor',vrep.simx_opmode_blocking);
        [~,block]=vrep.simxGetObjectHandle(clientID,'Romp',vrep.simx_opmode_blocking);
        [~,Sensor_motor]=vrep.simxGetObjectHandle(clientID,'Sensor_motor',vrep.simx_opmode_blocking);
        ori_sensor=[0 0 0];
        %% Other code
        %Start Sensor Lectures Streaming
        [~,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_streaming);
        [~,block_position]=vrep.simxGetObjectPosition(clientID,block,-1,vrep.simx_opmode_streaming); %-1 for absolute position 
        [returnCode,eulerAngles]=vrep.simxGetObjectOrientation(clientID,block,-1,vrep.simx_opmode_streaming);
        [~,ori_sensor(3)]=vrep.simxGetJointPosition(clientID,Sensor_motor,vrep.simx_opmode_streaming);
        %%
        i=0;
        d=norm(detectedPoint); % valor abosulto de la distancia del sensor, sin norm es un vector
        
        Sensor_body_v=setVelocity(clientID,50,Sensor_motor,vrep); %Velocidad de giro del motor 
        
        %%    
        for j=1:150; % 150 tiempo que corre la simulación 
          
           while detectionState==0 % si no detecta objecto, buscar una pared girando a la izquierda
            [returnCode,block_position]=vrep.simxGetObjectPosition(clientID,block,-1,vrep.simx_opmode_buffer);
            [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_buffer);           
            [returnCode,eulerAngles]=vrep.simxGetObjectOrientation(clientID,block,-1,vrep.simx_opmode_buffer);
            d=norm(detectedPoint);
            
            % modificar velocidad de las 4 llantas
            vel_rF=setVelocity(clientID,0,right_front,vrep); 
            vel_rB=setVelocity(clientID,0,right_back,vrep);
            vel_lF=setVelocity(clientID,0,left_front,vrep);
            vel_lB=setVelocity(clientID,0,left_back,vrep);
          i=i+1;
          if d>6
              d=6;
          end
          graficar(i,d,block_position,ori_sensor,detectionState)
           
           end
           %%
           while detectionState>0 % si hay un objecto evadirlo y girar a la derecha
               i=i+1;
            [returnCode,block_position]=vrep.simxGetObjectPosition(clientID,block,-1,vrep.simx_opmode_buffer);
            [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_buffer); 
            [returnCode,eulerAngles]=vrep.simxGetObjectOrientation(clientID,block,-1,vrep.simx_opmode_buffer);
            d=norm(detectedPoint);
            [~,ori_sensor(3)]=vrep.simxGetJointPosition(clientID,Sensor_motor,vrep.simx_opmode_buffer); %Posición del motor del sensor
            vel_rF=setVelocity(clientID,3,right_front,vrep);
            vel_rB=setVelocity(clientID,3,right_back,vrep);
            vel_lF=setVelocity(clientID,3,left_front,vrep);
            vel_lB=setVelocity(clientID,3,left_back,vrep);
             if d>6
              d=6;
           end
         graficar(i,d,block_position,ori_sensor,detectionState)
           end
            j=j+1;
          end
 end
 % Apagar los motores
            vel_rF=setVelocity(clientID,0,right_front,vrep);
            vel_rB=setVelocity(clientID,0,right_back,vrep);
            vel_lF=setVelocity(clientID,0,left_front,vrep);
            vel_lB=setVelocity(clientID,0,left_back,vrep);    
       vrep.sinmxFinish(-1); % acabar con la conexión
 vrep.delete();