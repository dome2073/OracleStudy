--Q21. S_EMP���̺��� �� ����� �̸��� �޿�, �޿������ ��Ÿ���ÿ�
--�޿��� 4000���� �̻��̸� A���, 3000���� �̻��̸� B���, 2000���� �̻��̸� C���, 1000�̻��̸� D���, 1000���ϴ� E��� 
--(sal_grade���̺� ��������ʰ� decode()�� ����Ұ�)

select name, salary, decode(trunc(salary/1000), 0 , 'E', 1, 'D' , 2, 'C', 3, 'B', 'A') �޿����
from s_emp;

--Q22. �ڽ��� �޿��� �ڽ��� ���� �μ��� ��պ��� ���� ������ ���� �̸�, �޿�, �μ� ��ȣ�� ���
select name, salary, dept_id
from s_emp outer
where salary < (select avg(salary)
                from s_emp
                where dept_id = outer.dept_id)
;
--�μ��� ���
select dept_id, avg(salary)
from s_emp
group by dept_id
;
select * from s_emp;
--Q23.������ �޿��� �� �μ��� ��� �޿��� ��� �� �μ��� ��ձ޿�����
-- ���� �޿��� �޴� ������ ���� �̸�, �޿�, �μ���ȣ�� ����ϼ���
select name, salary, dept_id
from s_emp 
where salary < any (select avg(salary) from s_emp group by dept_id)
;
--Q24.������ �ٸ� ����� ������(manager_id)�� �Ǿ��ִ� ������ ���, �̸�, ��å, �μ���ȣ�� ��Ÿ���ÿ�

select id, name, title, dept_id
from s_emp e
where exists (select id from s_emp where e.id = manager_id);

--Q25. ����(s_emp) ���̺��� �̸��� ���������� �����Ͽ� 5���� �����͸� ��Ÿ���ÿ�.
select name
from    (select name
        from s_emp
        order by 1 asc) 
where rownum <=5
;
                                
                                    
