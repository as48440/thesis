function fis = create_fis(chromosome)

    fis = mamfis(Name = 'evflc_ga');
    fis = addInput(fis, [-100 400], Name = 'price'); % Price = Input 1
    fis = addInput(fis, [0 1], Name = 'SoC'); % SoC = Input 2
    fis = addOutput(fis,[-12 12], Name = 'power'); % Power = Output 

     % Populate membership functions with the chromosome 
    fis = addMF(fis,'price','trimf', [-100 -100 chromosome(1)]);
    fis = addMF(fis,'price','trimf', [-100 chromosome(1:2)]);
    fis = addMF(fis,'price','trimf', [chromosome(1:3)]);
    fis = addMF(fis,'price', 'trimf', [chromosome(2:3) 400]);
    fis = addMF(fis,'price', 'trimf', [chromosome(3) 400 400]);

    fis = addMF(fis,'SoC','trimf', [0 0 chromosome(4)]);
    fis = addMF(fis,'SoC','trimf', [0 chromosome(4:5)]);
    fis = addMF(fis,'SoC','trimf', [chromosome(4:6)]);
    fis = addMF(fis,'SoC', 'trimf', [chromosome(5:6) 1]);
    fis = addMF(fis,'SoC', 'trimf', [chromosome(6) 1 1]);

    fis = addMF(fis,'power','trimf', [-12 -12 chromosome(7)]);
    fis = addMF(fis,'power','trimf', [-12 chromosome(7:8)]);
    fis = addMF(fis,'power','trimf', chromosome(7:9));
    fis = addMF(fis,'power','trimf', [chromosome(8:9) 12]);
    fis = addMF(fis,'power', 'trimf', [chromosome(9) 12 12]);

    ruleList = [1 1 5 1 1;
                2 1 5 1 1;
                3 1 4 1 1;
                4 1 4 1 1;
                5 1 3 1 1;
                1 2 5 1 1;
                2 2 4 1 1;
                3 2 4 1 1;
                4 2 3 1 1;
                5 2 2 1 1;
                1 3 4 1 1;
                2 3 4 1 1;
                3 3 3 1 1;
                4 3 2 1 1;
                5 3 2 1 1;
                1 4 4 1 1;
                2 4 3 1 1;
                3 4 2 1 1;
                4 4 2 1 1;
                5 4 1 1 1;
                1 5 3 1 1;
                2 5 2 1 1;
                3 5 2 1 1;
                4 5 1 1 1;
                5 5 1 1 1];
    fis = addRule(fis, ruleList);

end