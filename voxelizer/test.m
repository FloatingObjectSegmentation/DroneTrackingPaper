neki = 'data/results/targets';
neki2 = 'data/results/examples';
some = 400;

targets = zeros(some, 1);
for i = 0:1:some
    target = load(join([neki, '/', string(i), '.mat'], ''));
    target = target.target;
    targets(i+1) = target;
end

indices = find(targets == 1);
for i = 1:1:size(indices, 1)
    idx = indices(i) - 1;
    a = load(join([neki2, '/', string(idx), '.mat'], ''));
    plot_descriptor(a.objectField);
end