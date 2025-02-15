
function [Z] = SDP(num_sensors, Pairwise_Sensor_Distance, Sensor_Anchor_Distance, anchors)
% SPD.m
% Inputs: The total number of sensors num_sensors, a 3 column matrix 
% Pairwise_Sensor_Distance with indecies of the sensor(i), sensor(j) and 
% the distance between them in its columnsm, a 3 column matrix 
% Sensor_Anchor_Distance with columns: sensor indecies, anchor indecies and
% the distance between them, and finally all the anchors.
%
% This funciton estimates locations of n sensors in 1, 2 or 3D plane by 
% using CVX.
%
% Returns: n+dxn+d matrix Z which last length(anchors(:,1)) rows and first
% d columns are the estimated locations of the sensors.



%% Solves the convex problem with the SDP relaxation.
a = anchors;
% Number of sensors and anchors iterations.
num_s = length(Pairwise_Sensor_Distance(:, 1));
num_a = length(Sensor_Anchor_Distance(:, 1));

% Number of sensors and anchors
d = length(anchors(:, 1));
n = num_sensors;


cvx_begin sdp quiet
            %% Discuss what do to with the size here.
            variable Z(n+d,n+d) symmetric
            minimize(0)
            subject to
            
           Z(1:d, 1:d) == eye(d, d);
            
            for i=1:num_s
                ei = zeros(1, num_sensors);
                ei(1, Pairwise_Sensor_Distance(i, 1)) = 1;
                
                ej = zeros(1, num_sensors);
                ej(1, Pairwise_Sensor_Distance(i, 2)) = 1;
                
                sum(dot([zeros(1, d)';(ei-ej)']*[zeros(1, d)';(ei-ej)']', Z)) == Pairwise_Sensor_Distance(i, 3)^2;
            end
            
            
            for j = 1:num_a
                ej = zeros(1, num_sensors);
                ej(1, Sensor_Anchor_Distance(j, 1)) = 1;
                
                sum(dot([anchors(:, int64(Sensor_Anchor_Distance(j, 2))); -ej'] * [anchors(:, int64(Sensor_Anchor_Distance(j, 2))); -ej']',  Z))...
                    == Sensor_Anchor_Distance(j, 3)^2;
            end

            Z >= 0;           
cvx_end
    
end 
