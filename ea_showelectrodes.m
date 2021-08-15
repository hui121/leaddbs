function [el_render,el_label]=ea_showelectrodes(options,resultfig,elstruct,pt,el_render,el_label)

%
if ~exist('elstruct','var')
                [coords_mm,trajectory,markers]=ea_load_reconstruction(options);
            elstruct(1).coords_mm=coords_mm;
            elstruct(1).trajectory=trajectory;
            elstruct(1).name=options.patientname;
            elstruct(1).markers=markers;
end
if ~exist('pt','var')
    pt=1;
end

% show electrodes..
popts=options;
if strcmp(options.leadprod,'group')
    try
        directory=[options.patient_list{elstruct(pt).pt},filesep];
        [popts.root,popts.patientname]=fileparts(directory);
        popts.root=[popts.root,filesep];
    catch
        directory=[options.root,options.patientname,filesep];
    end
    
    popts=ea_detsides(popts);
else
    directory=[options.root,options.patientname,filesep];
end

elSide{pt}=popts.sides;

for side=elSide{pt}
    try
        pobj=ea_load_electrode(directory,side);
        pobj.hasPlanning=1;
        pobj.showPlanning=strcmp(options.leadprod,'or');
    end
    pobj.pt=pt;
    pobj.options=popts;
    pobj.elstruct=elstruct(pt);
    pobj.showMacro=1;
    pobj.side=side;
    
    set(0,'CurrentFigure',resultfig);
    if exist('el_render','var')
        el_render(end+1)=ea_trajectory(pobj);
    else
        el_render(1)=ea_trajectory(pobj);
    end
    
    if ~exist('ellabel','var')
        el_label=el_render(end).ellabel;
    else
        try
            el_label(end+1)=el_render(end).ellabel;
        end
    end
end