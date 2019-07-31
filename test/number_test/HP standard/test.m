function b= test(a)
  if a==1
      b=2;
    return;
  end
  disp('aa')
   
  try
      bb
  catch
      disp(a);
  end
  
  disp('bb')
end

