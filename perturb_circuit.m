function circuit = perturb_circuit(circuit, motif)
% Elements of circuit cell array: circuit{1} = w_sr, circuit{2} = w_ss, 
%   circuit{3} = w_pr, circuit{4} = w_ps;
num_sin = size(circuit{1}, 1);
num_rgc = size(circuit{1}, 2);
num_pvn = size(circuit{3}, 1);

switch(motif)
    case 1
        % no reciprocal inhibition
        circuit{2} = zeros(num_sin);
        
    case 2
        % no SIN 1
        circuit{2}(:, 1) = 0;
        circuit{2}(1, :) = 0;

        % pvn projection
        circuit{4}(2, 1) = 0;        
        
        % rgc innervation
        circuit{1}(1, :) = 0;
        
    case 3
        % no SIN 1 or SIN 2
        circuit{2} = zeros(num_sin);
        
        circuit{4}(:, 1) = 0;
        circuit{4}(:, 2) = 0;
        
        circuit{1}(1, :) = 0;
        circuit{1}(2, :) = 0;
    case 4
        % no SINs
        circuit{2} = zeros(num_sin);
        circuit{4} = zeros(num_pvn, num_sin);
        circuit{1} = zeros(num_sin, num_rgc);
end

