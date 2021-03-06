%----------------------------------------------------------------------%
%This subroutine builds the RHS vector for the Strong Form DGM-SEM
%on Quadrilateral Elements for the 2D Euler Equations.
%Written by Francis X. Giraldo on 1/2001
%           Department of Applied Mathematics
%           Naval Postgraduate School 
%           Monterey, CA 93943-5216
%----------------------------------------------------------------------%
function rhs = compute_rhs_dg_TensorProduct_inexact(q,u,v,ksi_x,ksi_y,eta_x,eta_y,jac,...
		 dpsi,nelemT,ngl,sfc,nsfc)

%global arrays
rhs=zeros(nelemT,ngl,ngl);

%Construct FEM-type Operators
for is=1:nsfc
    ie = sfc(is);
    %Loop Integration Points
    for i2=1:ngl
    for i1=1:ngl
        wq=jac(ie,i1,i2);
        e_x=ksi_x(ie,i1,i2);
        e_y=ksi_y(ie,i1,i2);
        n_x=eta_x(ie,i1,i2);
        n_y=eta_y(ie,i1,i2);

        %Interpolate at Integration Point
        u_k=u(ie,i1,i2);
        v_k=v(ie,i1,i2);
        q_k=q(ie,i1,i2);
        f_k=q_k*u_k;
        g_k=q_k*v_k;

        %Interpolate at Integration Points
	    for k=1:ngl
            dhqde=dpsi(k,i1)*( e_x*f_k + e_y*g_k );
            rhs(ie,k,i2)=rhs(ie,k,i2) + wq*dhqde;
            
            dhqdn=dpsi(k,i2)*( n_x*f_k + n_y*g_k );
            rhs(ie,i1,k)=rhs(ie,i1,k) + wq*dhqdn;
        end %k
    end %i1
    end %i2
end %ie
	    


