function [estimated_sensors, fvals, gvals] = Regression_CVX_Q1(num_sensors, Pairwise_Sensor_Distance, Sensor_Anchor_Distance, anchors)

% Number of sensors and anchors iterations.
num_s = length(Pairwise_Sensor_Distance(:, 1))
num_a = length(Sensor_Anchor_Distance(:, 1))
size(Sensor_Anchor_Distance)

% Number of sensors and anchors
d = length(anchors(:, 1));
n = num_sensors;


% Number of sensors and anchors
d = length(anchors(:, 1))
n = num_sensors


cvx_begin 
            %% Discuss what do to with the size here.
            
            variable x(d, n);
            z = 0;
            for i=1:num_s
                diff = x(:,Pairwise_Sensor_Distance(i,1)) - x(:,Pairwise_Sensor_Distance(i,2));
                tmp = diff'*diff - Sensor_Anchor_Distance(i,3).^2
                z = z + power(2,tmp);
            end
            
            for i=1:num_a
                Sensor_Anchor_Distance(i,2)
                diff = anchors(:,Sensor_Anchor_Distance(i,2)) - x(:,Sensor_Anchor_Distance(i,1));
                tmp = diff'*diff - Sensor_Anchor_Distance(i,3).^2;
                z = z + power(2,tmp);
            end
            
            
            minimize(z);
            
cvx_end

estimated_sensors = x;



end
