%%main file 


%% Core Design Input



KVA  = (input("Enter KVA Rating : "));
Phases = (input("Enter number of phases : "));
Frequency  = (input("Enter frequency of machine : "));
Primary_voltage = (input("Enter primary Voltage of Transformer : "));
Secondary_voltage = (input ("Enter Secondary Voltage of Transformer : "));

Bm = input("Enter the value of maximum flux Density : ");

Ks = input("Enter the stacking factor :  ");

Current_Density = input("Enter the Current Density Value : ");

Height_width_ratio = input ("Enter the Height to width ratio of transformer : ");

Stepping = input("Press 1 for Square stepping \nPress 2 for 2 Step \nPress 3 for 3 Step \nPress 4 for 4 Steps :");

Transformer_type = input ("Choose 1 for Single phase Shell type \nChoose 2 for Single phase core type \nChoose 3 for Three phase Core Distribution type \nChoose 4 for Three phase core Power type :" );

Type = input("Press 1 for HRC \nPress 2 for CRGO : ");


 %% Calculating  Phase Voltage of LV and HV
 
 LV = min(Primary_voltage , Secondary_voltage);
 HV = max(Primary_voltage , Secondary_voltage);

 if (Phases == 3)
        LV_type = input("Press 1 if LV Winding is Star\nPress 2 if LV Winding is Delta :");
        HV_type = input("Press 1 if HV Winding is Star\nPress 2 if HV Winding is Delta : ");
        if (LV_type == 1)
            LV_phase = LV/sqrt(3);
        elseif (LV_type == 2)
            LV_phase = LV;
        end    
 
        if (HV_type == 1)
            HV_phase = HV/sqrt(3);
        elseif (HV_type == 2)
            HV_phase = HV;
        end    
 else
     LV_phase = LV;
     HV_phase = HV;
 end
 %% leakage reactance input 
 
 
Length_mean_turn_primary = input('Enter Length Mean turn of primary : ');

Length_mean_turn_Secondary = input('Enter Length Mean turn of Secondary : ');

Length_mean_turn_overall = mean([Length_mean_turn_primary ,Length_mean_turn_Secondary ]);

Lc = input('Enter Length of coil :  ');

bp = input('Enter Thickness of primary :  ');

bs = input('Enter Thickness of Secondary : ');

a = input('Enter Width of duct : ');

rho = input('Enter resistivity of winding : ');

%% Voltage Regulation Input

cos_theta = input('Enter the value of power factor : ');


%% No load current input 

li = input('Enter the Length of iron : ' );

density = input ('Enter the density of the iron : ');

Loss_per_kg = input('Enter loss per kg of iron : ');

%% Tank Design Input


Cooling_surface_area = input('Enter the Area of the cooling Surface : ');

x = input('Enter the value of X ie ratio between \n surface area after inclusion of tubes and Cooling surface area : ');

length_tube = input('Enter the height of Tube : ');


%% we want the values of turns ratio , height of window , Width of core for LV and HV Design 
[Et , Hw , Wc  , Ai] = Core_design(KVA , Phases , Frequency , Primary_voltage , Secondary_voltage , Bm , Ks , Current_Density , Height_width_ratio , Stepping , Transformer_type ,Type);


%% we want the values of Turns of primary and secondary for calculating the leakage reactance of the 
[ Turns_primary , Turns_secondary , Area_of_one_conductor_primary , Area_of_one_conductor_secondary , Current_primary ,Current_secondary ,phase_voltage_primary , phase_voltage_secondary ] = LV_HV_Design(  KVA ,  Current_Density , Primary_voltage , Secondary_voltage , Phases , Et , Hw , Wc, LV_phase , HV_phase , LV ,HV );


%%  we want Total leackage reactance and resistance for calculating the Voltage regulation
[Total_Leakage_reactance_referred_primary , Total_resistance_referred_primary ] = Leakage_reactance(Frequency ,Turns_primary , Turns_secondary , Area_of_one_conductor_primary , Area_of_one_conductor_secondary ,Length_mean_turn_primary ,Length_mean_turn_Secondary ,Length_mean_turn_overall ,Lc , bp ,bs ,a ,rho ) 


%% Calculating Voltage Regulation 

 Voltage_reg = Voltage_regulation (Current_primary , phase_voltage_primary  , Total_Leakage_reactance_referred_primary , Total_resistance_referred_primary ,cos_theta)

%% No Load Current Calculation 

[Io ,Magnetic_VA ] = No_load_current(Bm , Ai ,Turns_primary , Phases , phase_voltage_primary , Frequency , li ,density ,Loss_per_kg)

%% Tank Design 

[Total_heat_dissipated , Dissipation ,Number_of_tubes] = Tank_design(Cooling_surface_area ,x , length_tube)



