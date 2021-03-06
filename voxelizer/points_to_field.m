function field = points_to_field(points, resolution, sigma)
%POINTS_TO_FIELD Transforms a point cloud to a voxel occupancy grid
%   points = Nx3 matrix of points to transform
%   resolution = integer value - how many bins is the total space

    % prepare field
    field = zeros(resolution, resolution, resolution);
    
    % move points to (0,0,0)
    points = points - min(points); % get to origin 0
    
    % scale so that maximum becomes 1 while preserving shape
    points = points ./ max(max(points));
    
    % pad so the object is centered
    padding = (1 - max(points)) ./ 2;
    points = points + repmat(padding, size(points, 1), 1);
    
    points = uint32(ceil(points * resolution));
    points(points == 0) = 1;
    for i = 1:1:size(points, 1)
        field(points(i, 1), points(i, 2), points(i,3)) = 1; % fill the bins where there are points
    end
    
    % still keep the gaussian because it codes for sparsity
    field = gauss3filter(field, sigma);
end

