function [muscles] = createmusclestruct(file)
    %createlocalpertwindow
    % SUMMARY: Creates a structure that accepts a file and creates a
    % string array of the short names,artisynth probe labels and its component id.

    T = readtable(file);
    ids = table2cell(T(:,1));
    names = table2cell(T(:,2));
    probeLabels = table2cell(T(:,3));

    muscles = struct('id', ids, 'name', names, 'probeLabel', probeLabels);