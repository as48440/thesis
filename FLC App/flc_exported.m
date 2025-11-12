classdef flc_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        State                         matlab.ui.control.DropDown
        distance                      matlab.ui.control.Label
        DistanceTravelledLabel        matlab.ui.control.Label
        elapsedtime                   matlab.ui.control.Label
        totaldegcost                  matlab.ui.control.Label
        totalchargingcost             matlab.ui.control.Label
        totaldistance                 matlab.ui.control.Label
        degcost                       matlab.ui.control.Label
        vehchargingcost               matlab.ui.control.Label
        TotalChargingCostLabel        matlab.ui.control.Label
        NetCostLabel                  matlab.ui.control.Label
        TotalDegradationCostLabel     matlab.ui.control.Label
        TotalDistanceTravelledLabel   matlab.ui.control.Label
        BatteryDegradationCostsLabel  matlab.ui.control.Label
        totalcost                     matlab.ui.control.Label
        VehicleChargingCostsLabel     matlab.ui.control.Label
        ResultsLabel                  matlab.ui.control.Label
        SimulationOutputPanel         matlab.ui.container.Panel
        GridLayout3                   matlab.ui.container.GridLayout
        availaxis                     matlab.ui.control.UIAxes
        priceaxis                     matlab.ui.control.UIAxes
        uaxis                         matlab.ui.control.UIAxes
        xaxis                         matlab.ui.control.UIAxes
        RunSimulationButton           matlab.ui.control.Button
        EndDateDatePicker             matlab.ui.control.DatePicker
        EndDateDatePickerLabel        matlab.ui.control.Label
        StartDateDatePicker           matlab.ui.control.DatePicker
        StartDateDatePickerLabel      matlab.ui.control.Label
        FISDropDown                   matlab.ui.control.DropDown
        FISDropDownLabel              matlab.ui.control.Label
        soc_3                         matlab.ui.control.Slider
        soc_5                         matlab.ui.control.Slider
        soc_4                         matlab.ui.control.Slider
        soc_2                         matlab.ui.control.Slider
        soc_1                         matlab.ui.control.Slider
        GridLayout2                   matlab.ui.container.GridLayout
        FuzzyLogicControlLabel        matlab.ui.control.Label
        SelectstartingSoCLabel        matlab.ui.control.Label
        vehicle_5                     matlab.ui.control.DropDown
        vehicle_4                     matlab.ui.control.DropDown
        vehicle_2                     matlab.ui.control.DropDown
        vehicle_3                     matlab.ui.control.DropDown
        profile_5                     matlab.ui.control.DropDown
        profile_4                     matlab.ui.control.DropDown
        profile_3                     matlab.ui.control.DropDown
        profile_2                     matlab.ui.control.DropDown
        profile_1                     matlab.ui.control.DropDown
        vehicle_1                     matlab.ui.control.DropDown
        n                             matlab.ui.control.Slider
        SelectavailabilityLabel       matlab.ui.control.Label
        SelectthevehiclemodelLabel    matlab.ui.control.Label
        NumberofvehiclesLabel         matlab.ui.control.Label
    end

    
    properties (Access = private)
        % Description
        price       
        SoC_dist
        arrival_dist
        departure_dist
    end
    
    methods (Access = private)
        

        %----- Retrieve user input values from the front end -----% 
        function [n,profiles,vehicles, soc, Nsim,start_date, ...
                start, end_date,T,fis] = retrieve_values(app)
            n = app.n.Value;
            profiles = [string(app.profile_1.Value); string(app.profile_2.Value); ...
                string(app.profile_3.Value); string(app.profile_4.Value);...
                string(app.profile_5.Value)];
            vehicles = [string(app.vehicle_1.Value); string(app.vehicle_2.Value);...
                string(app.vehicle_3.Value); string(app.vehicle_4.Value); ...
                string(app.vehicle_5.Value)];
            soc = [app.soc_1.Value; app.soc_2.Value; app.soc_3.Value ...
               ; app.soc_4.Value; app.soc_5.Value];
            Nsim = 288*days(app.EndDateDatePicker.Value - app.StartDateDatePicker.Value);
            start_date = convertTo(app.StartDateDatePicker.Value,'epochtime','Epoch','2024-01-01')/(60*60*24);
            start = start_date * 288;
            end_date = app.EndDateDatePicker.Value;
            T = 1/12;
            fis = app.FISDropDown.Value;

            % Truncate to only the relevant vehicles
            profiles = profiles(1:n);
            soc = soc(1:n);
            vehicles = vehicles(1:n);
        end

        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Load in necessary files
            app.arrival_dist = load ("arrival_dist.mat");
            app.departure_dist = load("departure_dist.mat");
            app.SoC_dist = load("SoC_dist.mat");   

            % Initialise components
            app.n.Value = 1;
            app.EndDateDatePicker.Value = datetime(2024,1,2);
            app.StartDateDatePicker.Value = datetime(2024,1,1);

            % Initiliase vehicle visibility to 1
            app.profile_1.Visible = 'on';
            app.vehicle_1.Visible = 'on';
            app.soc_1.Visible = 'on';
            app.profile_2.Visible = 'off';
            app.profile_3.Visible = 'off';
            app.profile_4.Visible = 'off';
            app.profile_5.Visible = 'off';
            app.vehicle_2.Visible = 'off';
            app.vehicle_3.Visible = 'off';
            app.vehicle_4.Visible = 'off';
            app.vehicle_5.Visible = 'off';
            app.soc_2.Visible = 'off';
            app.soc_3.Visible = 'off';
            app.soc_4.Visible = 'off';
            app.soc_5.Visible = 'off';

        end

        % Value changed function: n
        function nValueChanged(app, event)
            value = app.n.Value;

            if (ge(value,1))
                app.profile_1.Visible = 'on';
                app.vehicle_1.Visible = 'on';
                app.soc_1.Visible = 'on';
            else
                app.profile_1.Visible = 'off';
                app.vehicle_1.Visible = 'off';
                app.soc_1.Visible = 'off';

            end
            if (ge(value,2))
                app.profile_2.Visible = 'on';
                app.vehicle_2.Visible = 'on';
                app.soc_2.Visible = 'on';
            else
                app.profile_2.Visible = 'off';
                app.vehicle_2.Visible = 'off';
                app.soc_2.Visible = 'off';
            end
            if (ge(value,3))
                app.profile_3.Visible = 'on';
                app.vehicle_3.Visible = 'on';
                app.soc_3.Visible = 'on';
            else
                app.profile_3.Visible = 'off';
                app.vehicle_3.Visible = 'off';
                app.soc_3.Visible = 'off';
            end
            if (ge(value,4))
                app.profile_4.Visible = 'on';
                app.vehicle_4.Visible = 'on';
                app.soc_4.Visible = 'on';
            else
                app.profile_4.Visible = 'off';
                app.vehicle_4.Visible = 'off';
                app.soc_4.Visible = 'off';
            end
            if (ge(value,5))
                app.profile_5.Visible = 'on';
                app.vehicle_5.Visible = 'on';
                app.soc_5.Visible = 'on';
            else
                app.profile_5.Visible = 'off';
                app.vehicle_5.Visible = 'off';
                app.soc_5.Visible = 'off';
            end

            
            
        end

        % Button pushed function: RunSimulationButton
        function RunSimulationButtonPushed(app, event)
            % Retrieve input values from the app
            [n,profiles,vehicles, soc, Nsim,start_date, ...
                start, end_date,T, fis] = retrieve_values(app);
            pd_departure = app.departure_dist.pd_departure;
            pd_arrival = app.arrival_dist.pd_arrival;
            SoCdist = app.SoC_dist.SoC_dist;

            % Load the correct price file
            if (app.State.Value == "SA")
                app.price = load('sa_prices.mat');
                price = app.price.sa_prices;
            elseif (app.State.Value == "NSW")
                app.price = load('prices.mat');
                price = app.price.prices;
            end

            % Load in the correct FLC
            if (fis == "Default FIS")
                FLC = readfis("FLC_original.fis");
            elseif (fis == "GA FIS")
                FLC = readfis("FLC_GA_optimised.fis");
            elseif (fis == "GA + Battery FIS")
                FLC = readfis("FLC_GA_optimised_batt.fis");
            end
            
            % Set the availability matrix
            [avail_matrix, km_driven] = set_availability(n, Nsim, profiles, pd_arrival, pd_departure, SoCdist);
            
            % Set battery parameters 
            [Eb, Cb, consumption,lambda] = battery_parameters(n,vehicles);

            % Run the simulation
            [elapsedTime, vehicle_cost, vehicle_batt_cost,x,u] = run_simulation(n,...
                Nsim, soc, avail_matrix, consumption, Eb, lambda, Cb, T,start,...
                 price, km_driven, vehicles, FLC);

            % Display the output
            app.vehchargingcost.Text = "$ "+ mat2str(round(sum(vehicle_cost,2)',2));
            app.degcost.Text = "$ "+ mat2str(round(sum(vehicle_batt_cost,2)',2));
            app.totalchargingcost.Text = "$ " + round(sum(vehicle_cost(:)),2);
            app.totaldegcost.Text = "$ " + round(sum(vehicle_batt_cost(:)),2);
            app.distance.Text = mat2str(round(sum(km_driven,2)',2)) + " km";
            netcost = round(sum(vehicle_cost(:)) + sum(vehicle_batt_cost(:)),2);
            app.totalcost.Text = ["$ " + netcost];
            app.elapsedtime.Text = "Elapsed Time: " + round(elapsedTime,2) + " s";
            app.totaldistance.Text = round(sum(km_driven(:)),2) + " km";

            % Create the plot
            cla([app.xaxis app.uaxis app.priceaxis app.availaxis]);

            hold (app.xaxis,'on')
            for (v = 1:n)
                plot(app.xaxis,x(v,:));
            end
            hold (app.xaxis,'off')
            ylim(app.xaxis,[-0.1,1.1])
            xlim(app.xaxis,[0 Nsim]);
            xticks(app.xaxis,linspace(0,Nsim,Nsim/288+1));
            xticklabels(app.xaxis,linspace(0,Nsim,Nsim/288+1)/288);

            hold (app.uaxis,'on') 
            for v=1:n
                plot(app.uaxis,u(v,:));
            end
            hold (app.uaxis,'off')
            ylim(app.uaxis,[-15,15])
            xlim(app.uaxis,[0 Nsim])
            xticks(app.uaxis,linspace(0,Nsim,Nsim/288+1));
            xticklabels(app.uaxis,linspace(0,Nsim,Nsim/288+1)/288);
        
            plot(app.priceaxis,price(1+start:Nsim+start))
            xlim(app.priceaxis,[0 Nsim])
            xticks(app.priceaxis,linspace(0,Nsim,Nsim/288+1));
            xticklabels(app.priceaxis,linspace(0,Nsim,Nsim/288+1)/288);
        
            hold (app.availaxis,'on')
            for v = 1:n
                plot(app.availaxis,avail_matrix(v,:));
            end
            hold (app.availaxis,'off')
            xlim(app.availaxis,[0 Nsim])
            xticks(app.availaxis,linspace(0,Nsim,Nsim/288+1));
            xticklabels(app.availaxis,linspace(0,Nsim,Nsim/288+1)/288);

            % Extra data
            net_power_contribution = sum(u,1);
            %disp(net_power_contribution);
            assignin('base', 'flc_contrib', net_power_contribution');
            assignin('base','soc_out', x(1,:)');

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1062 567];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {150, 150, 150, 35, 35, '1x', '1x', 35};
            app.GridLayout.RowHeight = {44, 35, 15, 35, 35, 35, 35, 35, 15, 15, 15, 15, 15, 15, 15, 15};

            % Create NumberofvehiclesLabel
            app.NumberofvehiclesLabel = uilabel(app.GridLayout);
            app.NumberofvehiclesLabel.Layout.Row = 2;
            app.NumberofvehiclesLabel.Layout.Column = 1;
            app.NumberofvehiclesLabel.Text = 'Number of vehicles:';

            % Create SelectthevehiclemodelLabel
            app.SelectthevehiclemodelLabel = uilabel(app.GridLayout);
            app.SelectthevehiclemodelLabel.Layout.Row = 3;
            app.SelectthevehiclemodelLabel.Layout.Column = 1;
            app.SelectthevehiclemodelLabel.Text = 'Select the vehicle model:';

            % Create SelectavailabilityLabel
            app.SelectavailabilityLabel = uilabel(app.GridLayout);
            app.SelectavailabilityLabel.Layout.Row = 3;
            app.SelectavailabilityLabel.Layout.Column = 2;
            app.SelectavailabilityLabel.Text = 'Select availability:';

            % Create n
            app.n = uislider(app.GridLayout);
            app.n.Limits = [1 5];
            app.n.MajorTicks = [1 2 3 4 5];
            app.n.ValueChangedFcn = createCallbackFcn(app, @nValueChanged, true);
            app.n.Step = 1;
            app.n.Layout.Row = 2;
            app.n.Layout.Column = 2;
            app.n.Value = 5;

            % Create vehicle_1
            app.vehicle_1 = uidropdown(app.GridLayout);
            app.vehicle_1.Items = {'Nissan Leaf', 'Tesla Model Y', 'Kia EV6', 'MG 4'};
            app.vehicle_1.Layout.Row = 4;
            app.vehicle_1.Layout.Column = 1;
            app.vehicle_1.Value = 'Nissan Leaf';

            % Create profile_1
            app.profile_1 = uidropdown(app.GridLayout);
            app.profile_1.Items = {'Always Available', 'Long Commuter', 'Short Commuter', 'Split Availability', 'Probabilistic'};
            app.profile_1.Layout.Row = 4;
            app.profile_1.Layout.Column = 2;
            app.profile_1.Value = 'Always Available';

            % Create profile_2
            app.profile_2 = uidropdown(app.GridLayout);
            app.profile_2.Items = {'Always Available', 'Long Commuter', 'Short Commuter', 'Split Availability', 'Probabilistic'};
            app.profile_2.Layout.Row = 5;
            app.profile_2.Layout.Column = 2;
            app.profile_2.Value = 'Always Available';

            % Create profile_3
            app.profile_3 = uidropdown(app.GridLayout);
            app.profile_3.Items = {'Always Available', 'Long Commuter', 'Short Commuter', 'Split Availability', 'Probabilistic'};
            app.profile_3.Layout.Row = 6;
            app.profile_3.Layout.Column = 2;
            app.profile_3.Value = 'Always Available';

            % Create profile_4
            app.profile_4 = uidropdown(app.GridLayout);
            app.profile_4.Items = {'Always Available', 'Long Commuter', 'Short Commuter', 'Split Availability', 'Probabilistic'};
            app.profile_4.Layout.Row = 7;
            app.profile_4.Layout.Column = 2;
            app.profile_4.Value = 'Always Available';

            % Create profile_5
            app.profile_5 = uidropdown(app.GridLayout);
            app.profile_5.Items = {'Always Available', 'Long Commuter', 'Short Commuter', 'Split Availability', 'Probabilistic'};
            app.profile_5.Layout.Row = 8;
            app.profile_5.Layout.Column = 2;
            app.profile_5.Value = 'Always Available';

            % Create vehicle_3
            app.vehicle_3 = uidropdown(app.GridLayout);
            app.vehicle_3.Items = {'Nissan Leaf', 'Tesla Model Y', 'Kia EV6', 'MG 4'};
            app.vehicle_3.Layout.Row = 6;
            app.vehicle_3.Layout.Column = 1;
            app.vehicle_3.Value = 'Nissan Leaf';

            % Create vehicle_2
            app.vehicle_2 = uidropdown(app.GridLayout);
            app.vehicle_2.Items = {'Nissan Leaf', 'Tesla Model Y', 'Kia EV6', 'MG 4'};
            app.vehicle_2.Layout.Row = 5;
            app.vehicle_2.Layout.Column = 1;
            app.vehicle_2.Value = 'Nissan Leaf';

            % Create vehicle_4
            app.vehicle_4 = uidropdown(app.GridLayout);
            app.vehicle_4.Items = {'Nissan Leaf', 'Tesla Model Y', 'Kia EV6', 'MG 4'};
            app.vehicle_4.Layout.Row = 7;
            app.vehicle_4.Layout.Column = 1;
            app.vehicle_4.Value = 'Nissan Leaf';

            % Create vehicle_5
            app.vehicle_5 = uidropdown(app.GridLayout);
            app.vehicle_5.Items = {'Nissan Leaf', 'Tesla Model Y', 'Kia EV6', 'MG 4'};
            app.vehicle_5.Layout.Row = 8;
            app.vehicle_5.Layout.Column = 1;
            app.vehicle_5.Value = 'Nissan Leaf';

            % Create SelectstartingSoCLabel
            app.SelectstartingSoCLabel = uilabel(app.GridLayout);
            app.SelectstartingSoCLabel.Layout.Row = 3;
            app.SelectstartingSoCLabel.Layout.Column = 3;
            app.SelectstartingSoCLabel.Text = 'Select starting SoC:';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GridLayout);
            app.GridLayout2.ColumnWidth = {'1x'};
            app.GridLayout2.RowHeight = {24};
            app.GridLayout2.Layout.Row = 1;
            app.GridLayout2.Layout.Column = [1 2];

            % Create FuzzyLogicControlLabel
            app.FuzzyLogicControlLabel = uilabel(app.GridLayout2);
            app.FuzzyLogicControlLabel.FontSize = 18;
            app.FuzzyLogicControlLabel.FontWeight = 'bold';
            app.FuzzyLogicControlLabel.Layout.Row = 1;
            app.FuzzyLogicControlLabel.Layout.Column = 1;
            app.FuzzyLogicControlLabel.Text = 'Fuzzy Logic Control';

            % Create soc_1
            app.soc_1 = uislider(app.GridLayout);
            app.soc_1.Limits = [0 1];
            app.soc_1.Layout.Row = 4;
            app.soc_1.Layout.Column = [3 4];
            app.soc_1.Value = 0.5;

            % Create soc_2
            app.soc_2 = uislider(app.GridLayout);
            app.soc_2.Limits = [0 1];
            app.soc_2.Layout.Row = 5;
            app.soc_2.Layout.Column = [3 4];
            app.soc_2.Value = 0.5;

            % Create soc_4
            app.soc_4 = uislider(app.GridLayout);
            app.soc_4.Limits = [0 1];
            app.soc_4.Layout.Row = 7;
            app.soc_4.Layout.Column = [3 4];
            app.soc_4.Value = 0.5;

            % Create soc_5
            app.soc_5 = uislider(app.GridLayout);
            app.soc_5.Limits = [0 1];
            app.soc_5.Layout.Row = 8;
            app.soc_5.Layout.Column = [3 4];
            app.soc_5.Value = 0.5;

            % Create soc_3
            app.soc_3 = uislider(app.GridLayout);
            app.soc_3.Limits = [0 1];
            app.soc_3.Layout.Row = 6;
            app.soc_3.Layout.Column = [3 4];
            app.soc_3.Value = 0.5;

            % Create FISDropDownLabel
            app.FISDropDownLabel = uilabel(app.GridLayout);
            app.FISDropDownLabel.HorizontalAlignment = 'right';
            app.FISDropDownLabel.Layout.Row = 9;
            app.FISDropDownLabel.Layout.Column = 1;
            app.FISDropDownLabel.Text = 'FIS';

            % Create FISDropDown
            app.FISDropDown = uidropdown(app.GridLayout);
            app.FISDropDown.Items = {'Default FIS', 'GA FIS', 'GA + Battery FIS'};
            app.FISDropDown.Layout.Row = 9;
            app.FISDropDown.Layout.Column = 2;
            app.FISDropDown.Value = 'Default FIS';

            % Create StartDateDatePickerLabel
            app.StartDateDatePickerLabel = uilabel(app.GridLayout);
            app.StartDateDatePickerLabel.HorizontalAlignment = 'right';
            app.StartDateDatePickerLabel.Layout.Row = 10;
            app.StartDateDatePickerLabel.Layout.Column = 1;
            app.StartDateDatePickerLabel.Text = 'Start Date';

            % Create StartDateDatePicker
            app.StartDateDatePicker = uidatepicker(app.GridLayout);
            app.StartDateDatePicker.Limits = [datetime([2024 1 1]) datetime([2024 12 31])];
            app.StartDateDatePicker.Layout.Row = 10;
            app.StartDateDatePicker.Layout.Column = 2;

            % Create EndDateDatePickerLabel
            app.EndDateDatePickerLabel = uilabel(app.GridLayout);
            app.EndDateDatePickerLabel.HorizontalAlignment = 'right';
            app.EndDateDatePickerLabel.Layout.Row = 11;
            app.EndDateDatePickerLabel.Layout.Column = 1;
            app.EndDateDatePickerLabel.Text = 'End Date';

            % Create EndDateDatePicker
            app.EndDateDatePicker = uidatepicker(app.GridLayout);
            app.EndDateDatePicker.Limits = [datetime([2024 1 1]) datetime([2024 12 31])];
            app.EndDateDatePicker.Layout.Row = 11;
            app.EndDateDatePicker.Layout.Column = 2;

            % Create RunSimulationButton
            app.RunSimulationButton = uibutton(app.GridLayout, 'push');
            app.RunSimulationButton.ButtonPushedFcn = createCallbackFcn(app, @RunSimulationButtonPushed, true);
            app.RunSimulationButton.BackgroundColor = [0.651 0.9294 0.2902];
            app.RunSimulationButton.FontWeight = 'bold';
            app.RunSimulationButton.Layout.Row = [10 11];
            app.RunSimulationButton.Layout.Column = [3 4];
            app.RunSimulationButton.Text = 'Run Simulation';

            % Create SimulationOutputPanel
            app.SimulationOutputPanel = uipanel(app.GridLayout);
            app.SimulationOutputPanel.Title = 'Simulation Output';
            app.SimulationOutputPanel.Layout.Row = [1 16];
            app.SimulationOutputPanel.Layout.Column = [6 7];
            app.SimulationOutputPanel.FontWeight = 'bold';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.SimulationOutputPanel);
            app.GridLayout3.ColumnWidth = {'1x'};
            app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create xaxis
            app.xaxis = uiaxes(app.GridLayout3);
            title(app.xaxis, 'State Variables')
            ylabel(app.xaxis, 'SoC/100%')
            app.xaxis.XTick = [0 1];
            app.xaxis.Layout.Row = 1;
            app.xaxis.Layout.Column = 1;

            % Create uaxis
            app.uaxis = uiaxes(app.GridLayout3);
            title(app.uaxis, 'Control Inputs')
            ylabel(app.uaxis, 'Power (kW)')
            app.uaxis.XTick = [0 1];
            app.uaxis.Layout.Row = 2;
            app.uaxis.Layout.Column = 1;

            % Create priceaxis
            app.priceaxis = uiaxes(app.GridLayout3);
            title(app.priceaxis, 'Optimisation Input')
            ylabel(app.priceaxis, 'Price ($)')
            app.priceaxis.XTick = [0 1];
            app.priceaxis.Layout.Row = 3;
            app.priceaxis.Layout.Column = 1;

            % Create availaxis
            app.availaxis = uiaxes(app.GridLayout3);
            title(app.availaxis, 'Vehicle Availability')
            xlabel(app.availaxis, 'Days')
            ylabel(app.availaxis, 'Availability')
            app.availaxis.XTick = [0 1];
            app.availaxis.Layout.Row = 4;
            app.availaxis.Layout.Column = 1;

            % Create ResultsLabel
            app.ResultsLabel = uilabel(app.GridLayout);
            app.ResultsLabel.FontWeight = 'bold';
            app.ResultsLabel.Layout.Row = 12;
            app.ResultsLabel.Layout.Column = 1;
            app.ResultsLabel.Text = 'Results';

            % Create VehicleChargingCostsLabel
            app.VehicleChargingCostsLabel = uilabel(app.GridLayout);
            app.VehicleChargingCostsLabel.HorizontalAlignment = 'right';
            app.VehicleChargingCostsLabel.Layout.Row = 13;
            app.VehicleChargingCostsLabel.Layout.Column = 1;
            app.VehicleChargingCostsLabel.Text = 'Vehicle Charging Costs:';

            % Create totalcost
            app.totalcost = uilabel(app.GridLayout);
            app.totalcost.FontSize = 18;
            app.totalcost.FontWeight = 'bold';
            app.totalcost.Layout.Row = [15 16];
            app.totalcost.Layout.Column = [4 5];
            app.totalcost.Text = '$ 0';

            % Create BatteryDegradationCostsLabel
            app.BatteryDegradationCostsLabel = uilabel(app.GridLayout);
            app.BatteryDegradationCostsLabel.HorizontalAlignment = 'right';
            app.BatteryDegradationCostsLabel.Layout.Row = 14;
            app.BatteryDegradationCostsLabel.Layout.Column = 1;
            app.BatteryDegradationCostsLabel.Text = 'Battery Degradation Costs:';

            % Create TotalDistanceTravelledLabel
            app.TotalDistanceTravelledLabel = uilabel(app.GridLayout);
            app.TotalDistanceTravelledLabel.HorizontalAlignment = 'right';
            app.TotalDistanceTravelledLabel.Layout.Row = 16;
            app.TotalDistanceTravelledLabel.Layout.Column = 1;
            app.TotalDistanceTravelledLabel.Text = 'Total Distance Travelled:';

            % Create TotalDegradationCostLabel
            app.TotalDegradationCostLabel = uilabel(app.GridLayout);
            app.TotalDegradationCostLabel.HorizontalAlignment = 'right';
            app.TotalDegradationCostLabel.Layout.Row = 14;
            app.TotalDegradationCostLabel.Layout.Column = 3;
            app.TotalDegradationCostLabel.Text = 'Total Degradation Cost:';

            % Create NetCostLabel
            app.NetCostLabel = uilabel(app.GridLayout);
            app.NetCostLabel.HorizontalAlignment = 'right';
            app.NetCostLabel.FontSize = 18;
            app.NetCostLabel.FontWeight = 'bold';
            app.NetCostLabel.Layout.Row = [15 16];
            app.NetCostLabel.Layout.Column = 3;
            app.NetCostLabel.Text = 'Net Cost:';

            % Create TotalChargingCostLabel
            app.TotalChargingCostLabel = uilabel(app.GridLayout);
            app.TotalChargingCostLabel.HorizontalAlignment = 'right';
            app.TotalChargingCostLabel.Layout.Row = 13;
            app.TotalChargingCostLabel.Layout.Column = 3;
            app.TotalChargingCostLabel.Text = 'Total Charging Cost:';

            % Create vehchargingcost
            app.vehchargingcost = uilabel(app.GridLayout);
            app.vehchargingcost.Layout.Row = 13;
            app.vehchargingcost.Layout.Column = [2 3];
            app.vehchargingcost.Text = '$ 0';

            % Create degcost
            app.degcost = uilabel(app.GridLayout);
            app.degcost.Layout.Row = 14;
            app.degcost.Layout.Column = [2 3];
            app.degcost.Text = '$ 0';

            % Create totaldistance
            app.totaldistance = uilabel(app.GridLayout);
            app.totaldistance.Layout.Row = 16;
            app.totaldistance.Layout.Column = 2;
            app.totaldistance.Text = '$ 0';

            % Create totalchargingcost
            app.totalchargingcost = uilabel(app.GridLayout);
            app.totalchargingcost.Layout.Row = 13;
            app.totalchargingcost.Layout.Column = [4 5];
            app.totalchargingcost.Text = '$ 0';

            % Create totaldegcost
            app.totaldegcost = uilabel(app.GridLayout);
            app.totaldegcost.Layout.Row = 14;
            app.totaldegcost.Layout.Column = [4 5];
            app.totaldegcost.Text = '$ 0';

            % Create elapsedtime
            app.elapsedtime = uilabel(app.GridLayout);
            app.elapsedtime.HorizontalAlignment = 'right';
            app.elapsedtime.Layout.Row = 1;
            app.elapsedtime.Layout.Column = [3 4];
            app.elapsedtime.Text = 'Elapsed Time: 0 s';

            % Create DistanceTravelledLabel
            app.DistanceTravelledLabel = uilabel(app.GridLayout);
            app.DistanceTravelledLabel.HorizontalAlignment = 'right';
            app.DistanceTravelledLabel.Layout.Row = 15;
            app.DistanceTravelledLabel.Layout.Column = 1;
            app.DistanceTravelledLabel.Text = 'Distance Travelled';

            % Create distance
            app.distance = uilabel(app.GridLayout);
            app.distance.Layout.Row = 15;
            app.distance.Layout.Column = [2 3];
            app.distance.Text = '$ 0';

            % Create State
            app.State = uidropdown(app.GridLayout);
            app.State.Items = {'NSW', 'SA'};
            app.State.Layout.Row = 9;
            app.State.Layout.Column = [3 4];
            app.State.Value = 'NSW';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = flc_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end