function Output = InputEqn(parameters,t,inputParameters)

persistent input inputparameters time;

if isempty(input) || ~isequal(inputparameters,inputParameters)
    inputparameters=inputParameters;
    power=inputparameters(1:2:end,:);
    duration=inputparameters(2:2:end,:);
    N=size(power,2);
    input=zeros(round(max(sum(duration,1))/parameters.sampleTime),N);
    time=0:parameters.sampleTime:size(input,1)*parameters.sampleTime;
    for j=1:N
        temp=[];
        for i=1:size(power,1)
            temp=[temp; repmat(power(i,j),round(duration(i,j)/parameters.sampleTime),1) ];
        end
        input(1:length(temp),j)=temp;
        input(length(temp)+1:end,j)=temp(end);
    end
end

index = find(t>=time,1,'last');

if index>size(input,1)
    Output = input(end,:);
else
    Output=input(index,:);
end
