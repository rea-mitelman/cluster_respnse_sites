function tf = unempty_exist(var_name)

expression = ['exist(' '''' var_name '''' ',' '''' 'var' '''' ');'];
tf=evalin('caller',expression);
if ~tf
    return
end
expression = ['~isempty(' var_name ');'];
tf=evalin('caller',expression);
