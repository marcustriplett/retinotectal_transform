function circuit = load_circuit(num_rgc, num_sin, num_pvn)

circuit = cell(4, 1);

% basic feedforward structure
w_sr = eye(3);

w_ps = zeros(num_pvn, num_sin);
w_ps(2, 1) = 1;
w_ps(2, 2) = 1;
w_ps(2, 3) = 1;

w_pr = zeros(num_pvn, num_rgc);
w_pr(1, 1) = 1;
w_pr(2, 1) = 1;
w_pr(2, 2) = 1;
w_pr(3, 2) = 1;
w_pr(4, 3) = 1;

% complete circuit
w_ss = ones(num_sin) - eye(num_sin); % enforce reciprocal inhibition

circuit{1} = w_sr;
circuit{2} = w_ss;
circuit{3} = w_pr;
circuit{4} = w_ps;

% normalise
for cc = 1:numel(circuit)
    s = sum(circuit{cc}(:));
    if s ~= 0
        circuit{cc} = circuit{cc}/s;
    end
end