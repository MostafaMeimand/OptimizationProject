# DEFINED PARAMS
param N_D; # Number of Duplex machine
param N_DO; # Number of cable types only on Duplex machine
param N_DR; # Number of cable types only on Duplex/Regular machine
param N_R; # Number of Regular machine
param N_T; # Number of cable types

#SETS
set I := {1..N_T}; # cable types
set I_D := {1..N_T}; # cable types that can be made on duplex machine
set I_DO := {1..N_DO}; # cable types that can be made only on duplex machine
set I_R := {N_DO+1..N_DO+N_DR}; # cable types that can be made only on duplex machine
set I_DR = I_R; # cable types that can be made only on duplex machine

# TIME PARAMETERES
param H_bar; # number of hours per day that machines operate
param D_bar; # number of days per week that machine operate
param W_bar; # number of weeks per quarter

# PARAMETERES
param A_D = N_D * H_bar * D_bar * W_bar; # Available hours on all Duplex machine
param A_R = N_R * H_bar * D_bar * W_bar; # Available hours on all Regular machine
param C_i {I}; # Production cost for cable type i($/yard)
param d_i {I}; # hours/yard required for cable type i on duplex machine
param O_i {I}; # Outsourced cost for cable type i
param Q_i {I}; # Demand for cable type i
param r_i {I}; # Hours/yard required for cable type i on regular machine
param Z_i {I}; # Selling price for cable type i


#DECISION VARIABLES
var D_i {j in I} >= 0; # Yards of cable type i to be made on Duplex machine
var R_i {j in I} >= 0; # Yards of cable type i to be made on Regular machine
var S_i {j in I} >= 0; # Yards of cable type i to be outsourced

# COMPUTED PARAMTERES
param P_i {j in I} = Z_i [j] - C_i [j]; # profit for cable type i if made by singular
param T_i {j in I} = Z_i [j] - O_i [j]; # profit for cable type i if outsourced

# OBJECTIVE FUNCTION
maximize z:
sum {j in I_D} -1 * C_i[j] * D_i[j] + 
sum {j in I_R} -1 * C_i[j] * R_i[j] + 
sum {j in I} -1 * O_i[j] * S_i[j];


#param n integer > 0; # NUMBER OF COLUMNS
s.t. Regular: sum {j in I_R} 1/r_i[j] * R_i[j] <= A_R;
s.t. Duplex:  sum {j in I_D} 1/d_i[j] * D_i[j] <= A_D;
s.t. Demand {j in I_R}: R_i[j] + D_i[j] + S_i[j] >= Q_i[j];
s.t. Demand_2 {j in I_DO}: D_i[j] + S_i[j] >= Q_i[j];

