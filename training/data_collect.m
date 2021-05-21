 vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m) 
  vrep.simxFinish(-1); % just in case, close all opened connections
  clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

  if (clientID>-1)
        disp('Connected to remote API server !');
        
        %code
        
        %handles
        %[returnCode, path_handle] = vrep.simxGetObjectHandle(clientID,'Path', vrep.simx_opmode_blocking);
%         [returnCode, robot_handle] = vrep.simxGetObjectHandle(clientID, 'Manta', vrep.simx_opmode_blocking);
%         
%         [returnCode,rear_motor] = vrep.simxGetObjectHandle(clientID,'motor_joint', vrep.simx_opmode_blocking);
%         [returnCode, front_steer] = vrep.simxGetObjectHandle(clientID,'steer_joint', vrep.simx_opmode_blocking);
%    
        [returnCode, robot_handle] = vrep.simxGetObjectHandle(clientID, 'Pioneer_p3dx', vrep.simx_opmode_blocking);  
        [returnCode,left_motor] = vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_leftMotor', vrep.simx_opmode_blocking);
         [returnCode, right_motor] = vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor', vrep.simx_opmode_blocking);
%    
        %[returnCode, detectionState, detectedPoint, ~] = vrep.simxReadProximitySensor(clientID, front_sensor, vrep.simx_opmode_streaming);
        for i=1:10
            %[returnCode, robot_handle] = vrep.simxLoadModel(clientID, 'manta with differential.ttm', 0, vrep.simx_opmode_blocking);
            %[returnCode]=vrep.simxSetObjectPosition(clientID, robot_handle, -1,[-5+i, -5+i, 0.2332] , vrep.simx_opmode_oneshot);
            init_pos = [-1.5+i*0.1, -1.5+i*0.1, 0.2];
            [res retInts retFloats retStrings retBuffer]=vrep.simxCallScriptFunction(clientID,'Dummycode',vrep.sim_scripttype_childscript,'resetObject2',robot_handle,init_pos,'',[],vrep.simx_opmode_blocking);
            pos_on_path = 0;
            dis = 0;
            index = 1;
            controlpts = 8;
            [returnCode,position]=vrep.simxGetObjectPosition(clientID, robot_handle, -1 ,vrep.simx_opmode_streaming);
            disp(position);
            
            for t=1:50 
                %[returnCode, detectionState, detectedPoint, ~] = vrep.simxReadProximitySensor(clientID, front_sensor, vrep.simx_opmode_buffer);
                [returnCode,position]=vrep.simxGetObjectPosition(clientID, robot_handle, -1 ,vrep.simx_opmode_buffer);
                disp(returnCode); 
                disp(position); 
                %call script funtion
                %[returnCode, ~,path_pos,~]=vrep.simxCallScriptFunction(clientID,'Dummy',vrep.sim_scripttype_childscript,'pathposcall',path_handle,-index-1,'',[],vrep.simx_opmode_blocking);
                
                
                %[returnCode, ~,path_pos_after,~]=vrep.simxCallScriptFunction(clientID,'Dummy',vrep.sim_scripttype_childscript ,'get_rot_pathpos_func', robot_handle,path_pos,'',[] ,vrep.simx_opmode_blocking);
     
                
%                 rear_mv = 0.1;
%                 steer_a = 0; 
%                 [returnCode] = vrep.simxSetJointTargetVelocity(clientID, rear_motor, rear_mv, vrep.simx_opmode_blocking);
%                 
                left_w = rand*10;
                right_w = rand*10;
                [returnCode] = vrep.simxSetJointTargetVelocity(clientID, left_motor, left_w, vrep.simx_opmode_blocking);
                [returnCode] = vrep.simxSetJointTargetVelocity(clientID, right_motor, right_w, vrep.simx_opmode_blocking);
%                 
                disp('vel sets');
                disp(returnCode);
                %[returnCode] = vrep.simxSetJointTargetVelocity(clientID, right_motor, -omega_r, vrep.simx_opmode_blocking);
                %[returnCode] = vrep.simxSetJointTargetPosition(clientID, front_steer, steer_a, vrep.simx_opmode_streaming);
                
                pause(0.1);
            end



            %[returnCode]= vrep.simxSetJointTargetVelocity(clientID, left_motor, 0, vrep.simx_opmode_blocking);
            %[returnCode]= vrep.simxSetJointTargetVelocity(clientID, right_motor, 0, vrep.simx_opmode_blocking);
        end
        vrep.simxFinish(-1);
  end
  
  vrep.delete();
  