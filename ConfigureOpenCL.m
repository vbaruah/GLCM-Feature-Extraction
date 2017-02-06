function OpenCL = ConfigureOpenCL()

%Configures OpenCL to work in the following order
% 1: AMD GPU
% 2: Intel GPU
% 3: Intel CPU
% 4: NVIDIA GPU

OpenCL = opencl();

Platforms = OpenCL.platforms;
SelectedPlatform = 0;

IntelPlatform = 0;
IntelPlatformIndex = 0;

AMDPlatform = 0;
AMDPlatformIndex = 0;

NVIDIAPlatform = 0;
NVIDIAPlatformIndex = 0;

DeviceAndPlatformConfigured = 0;

for i = 1:size(Platforms, 1)
    tempPlat = Platforms(i);    
        
    if(strfind(tempPlat.name, 'AMD'))
        AMDPlatform = tempPlat;
        AMDPlatformIndex = i;
    end
    
    if(strfind(tempPlat.name, 'Intel'))
        IntelPlatform = tempPlat;
        IntelPlatformIndex = i;
    end
    
    if(strfind(tempPlat.name, 'NVIDIA'))
        NVIDIAPlatform = tempPlat;
        NVIDIAPlatformIndex = i;
    end    
end

if(AMDPlatformIndex)
    devices = AMDPlatform.devices;

    CPUIndex = 0;
    GPUIndex = 0;
    
    for i = 1:size(devices, 1)
       if(strfind(devices(i).name, 'CPU'))
            CPUIndex = i;
       else
            GPUIndex = i;
       end
    end  
    
%     if(GPUIndex)
%        OpenCL.initialize(AMDPlatformIndex, GPUIndex); 
%        handles.OpenCL = OpenCL;
%        DeviceAndPlatformConfigured = 1;
%     end
    
    if(CPUIndex && DeviceAndPlatformConfigured == 0)
       OpenCL.initialize(AMDPlatformIndex, CPUIndex); 
       handles.OpenCL = OpenCL;
       DeviceAndPlatformConfigured = 1;
    end
end

if(IntelPlatformIndex && DeviceAndPlatformConfigured ~= 1)
    devices = IntelPlatform.devices;

    CPUIndex = 0;
    GPUIndex = 0;
    
    for i = 1:size(devices, 1)
       if(strfind(devices(i).name, 'CPU'))
            CPUIndex = i;
       else
            GPUIndex = i;
       end     
    end  
    
%     if(GPUIndex)
%        OpenCL.initialize(IntelPlatformIndex, GPUIndex); 
%        handles.OpenCL = OpenCL;
%        DeviceAndPlatformConfigured = 1;
%     end
    
    if(CPUIndex && DeviceAndPlatformConfigured == 0)
       OpenCL.initialize(IntelPlatformIndex, CPUIndex); 
       handles.OpenCL = OpenCL;
       DeviceAndPlatformConfigured = 1;
    end
end

%Add other programs here
OpenCL.addfile('OpenCL/Attenuation_32f.txt');
OpenCL.addfile('OpenCL/TextureAnalysis.txt');

OpenCL.build();
end

