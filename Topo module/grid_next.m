function [m_next,n_next]=grid_next(m,n,Flow_dir)
if Flow_dir(m,n)==0
    m_next=m;n_next=n;
elseif Flow_dir(m,n)==1
    m_next=m-1;n_next=n+1;
elseif Flow_dir(m,n)==2
    m_next=m;n_next=n+1;
elseif Flow_dir(m,n)==3
    m_next=m+1;n_next=n+1;
elseif Flow_dir(m,n)==4
    m_next=m+1;n_next=n;
elseif Flow_dir(m,n)==5
    m_next=m+1;n_next=n-1;
elseif Flow_dir(m,n)==6
    m_next=m;n_next=n-1;
elseif Flow_dir(m,n)==7
    m_next=m-1;n_next=n-1;
elseif Flow_dir(m,n)==8
    m_next=m-1;n_next=n;
end





