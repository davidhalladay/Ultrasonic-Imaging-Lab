fid = fopen('student.txt','r'); 
i = 1;
while ~feof(fid)
    name(i,:) = fscanf(fid,'%c',1);  
    test1(i) = fscanf(fid,'%g',1); 
    test2(i) = fscanf(fid,'%g',1); 
    test3(i) = fscanf(fid,'%g',1); 
    test4(i) = fscanf(fid,'%g\n',1); 
    i=i+1;
end
fclose(fid);