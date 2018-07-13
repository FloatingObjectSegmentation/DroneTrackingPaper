% Script takes all objects from scene scans and drone training set, and 
% transforms them to fit a regular voxel grid. Finally saves all of these
% descriptors to disk, along with their respective targets in the format:
%
%   descriptor = results/examples/<objectIndex>.mat
%   target = results/targets/<objectIndex>.mat

% SceneGen path
data_out = 'data/data_in';

% Scans path
scenefolder = 'data/scans/Scan';
scenesuffix = '00000.pcd';

% Outputs path
targets_folder = 'data/results/targets';
examples_folder = 'data/results/examples';

field_resolution = 50;
objectIndex = 0;

%% export voxelized scenes
for scene = 1:1:1000
    
    % try to read next scene
    try
        ptCloud = pcread(join([scenefolder, string(scene), scenesuffix], ''));
    catch except
        except
        join(['file missing for scene: ',  string(scene)], '')
        continue
    end
    
    % read the SceneGen data - object locations and the targets
    X = getfield(load(join([data_out, '/', string(scene), "data.mat"], '')), 'data');
    y = getfield(load(join([data_out, '/', string(scene), "classes.mat"], '')), 'classes');
    
    % segment the scene into clusters
    ClusterIndices = RBNN(ptCloud.Location, 4.0, 5);
    % segmentation_plot(ptCloud, ClusterIndices);

    % voxelize each object in the scene and save it
    for i = 1:1:size(X,1)

        % voxelize next object in the scene
        cid = segmentation_segsimple(ptCloud.Location, ClusterIndices, X(i, :));
        objectPts = ptCloud.Location(ClusterIndices == cid, :);
        centroid = sum(objectPts) ./ size(objectPts, 1);
        
        % sometimes the object is not scanned, so we should verify whether
        % it's really the object we think it is
        diff = norm(X(i,:) - centroid);
        if (y(i) == 1 && diff > 5) || (y(i) == 2 && diff > 30) || (y(i) == 3 && diff > 10)
           continue; % object hasn't been scanned    
        end
        
        sigma = (norm(centroid) / 200) * 2;
        objectField = points_to_field(objectPts, field_resolution, 0);

        % plot to verify correctness
        % plot_descriptor(objectField);
        % segmentation_plot(ptCloud, ClusterIndices);
        % plotcube([6,6,6], centroid - [3,3,3], .3, [1 0 1]);

        % store the descriptor and the target value
        target = y(i);
        save(join([examples_folder, '/', string(objectIndex), '.mat'], ''), 'objectField');
        save(join([targets_folder,  '/', string(objectIndex), '.mat'], ''), 'target');

        % update the object index
        objectIndex = objectIndex + 1;

    end
end