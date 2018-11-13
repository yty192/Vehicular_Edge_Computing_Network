clc;clear ;
Z=4;
M=7*Z;                          % The number of server
L_m=20;                         % The segment length
L_rd=5*Z*L_m;                   % The road length
L_rd_total=7*Z*L_m;             % The total length(m)  
v_speed=120*(1000/3600);        % speed of cars (m/s)
B_RSU=1.25*1000 ;               % Bandwith of the each RSU (HZ)
P_v=100*(10^(-3));              % the transmission power of each vehicle(watt)
N_v=10^(-13);                   % the noise power(watt) 

c_car = 0.4;
F_limit=15*ones(1,M);
buffer_number=4;

%initial condition 
%initial postion for the car driving to right
N_initial_right=randi([10,25]);
V_postion_x_right_initial=Z*L_m + 5*Z*L_m.*rand(N_initial_right,1);
V_postion_y_right_initial =rand(N_initial_right,1);
for ii=1:N_initial_right
    if V_postion_y_right_initial(ii) >=0.5
        V_postion_y_right_initial(ii)=8;
    else
        V_postion_y_right_initial(ii)=6;
    end
end
% initial position for the car driving to left 
N_initial_left=randi([10,25]);
V_postion_x_left_initial=Z*L_m +5*Z*L_m.*rand(N_initial_left,1);
V_postion_y_left_initial =rand(N_initial_left,1);
for ii=1:N_initial_left
    if V_postion_y_left_initial(ii) >=0.5
        V_postion_y_left_initial(ii)=4;
    else
        V_postion_y_left_initial(ii)=2;
    end
end
vehicle_position_initial=[V_postion_x_right_initial, V_postion_y_right_initial ;V_postion_x_left_initial,V_postion_y_left_initial];

% the new car came in with distribution of poisson 
recy_time=6;
%the car add to the direction right
lambda_right=10;
N_right_add=poissrnd(lambda_right);
V_positon_x_right_add= Z*L_m*ones(N_right_add,1);
V_positon_y_right_add= rand(N_right_add,1);

for ii=1: N_right_add
    if V_positon_y_right_add(ii) >=0.5
        V_positon_y_right_add(ii)=8;
    else
        V_positon_y_right_add(ii)=6;
    end
end


%the car added to the direction left
lambda_left=10;
N_left_add=poissrnd(lambda_left);
V_postion_x_left_add=Z*L_m*ones(N_left_add,1);
V_postion_y_left_add =rand(N_left_add,1);
for ii=1:N_left_add
    if V_postion_y_left_add(ii) >=0.5
        V_postion_y_left_add(ii)=4;
    else
        V_postion_y_left_add(ii)=2;
    end
end

V_postion_x_right_initial=V_postion_x_right_initial+v_speed* recy_time;
V_postion_x_left_initial =V_postion_x_left_initial -v_speed* recy_time;
vehicle_position=[V_positon_x_right_add,V_positon_y_right_add;V_postion_x_right_initial,V_postion_y_right_initial;V_postion_x_left_add,V_postion_y_left_add;V_postion_x_left_initial,V_postion_y_left_initial];

for ii= 1: length(vehicle_position)
    if (vehicle_position(ii,1)>= Z*L_m) && (vehicle_position(ii,1)<= 6*Z*L_m)
        vehicle_position(ii,1)=vehicle_position(ii,1);
    else
        vehicle_position(ii,1)=0;
    end
end

%take out the car not in the range 
vehicle_position_delete=vehicle_position;
delete_index=find(vehicle_position_delete(:,1)==0);
vehicle_position_delete(delete_index,:)=[];


% get the number of car right and left
N_right=0;
for ii=1: length(vehicle_position_delete)
    if (vehicle_position_delete(ii,2) == 6 ) |  (vehicle_position_delete(ii,2)==8 )
        N_right =N_right+1;
    end
end

N_left=0;
for ii=1: length(vehicle_position_delete)
    if (vehicle_position_delete(ii,2) == 2 ) |  (vehicle_position_delete(ii,2)==4 )
        N_left =N_left+1;
    end
end


%     
