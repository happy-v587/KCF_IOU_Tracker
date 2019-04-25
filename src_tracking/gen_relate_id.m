function [dids] = gen_relate_id(relate, ids)
%% get relate id from k-1
 % if this frame large than k-1, then let ids be -1
    r_size = size(relate, 2);
    dids = -1 * ones(r_size, 1);    
    [r, c] = find(relate == 1);        
    dids(c) = ids(r);        
end