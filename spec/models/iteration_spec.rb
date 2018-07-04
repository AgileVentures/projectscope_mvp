require 'rails_helper'

describe Iteration do
  describe 'abstract task graph' do
    it "should have task graph function" do
      skip
    end
  end

  describe 'hand over event call back' do
    skip
  end

  describe 'iteration tasks percentage calculation' do
    before(:each) do
      @iteration = create(:iteration)
      @pretask1 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'finished')
      @pretask2 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'started')
      @devtask1 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @devtask2 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @posttask1 = create(:task, :post, iteration_id: @iteration.id, task_status:'danger')
      @posttask2 = create(:task, :post, iteration_id: @iteration.id, task_status:'started')
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'should show the correct percentage' do
      @preliminaryTasks = @tasks.select{|task| task.updater_type == 'preliminary'}
      @devTasks = @tasks.select{|task| task.updater_type == 'development'}
      @postTasks = @tasks.select{|task| task.updater_type == 'post'}
      expect(@preliminaryTasks).not_to be_nil
      expect(@devTasks).not_to be_nil
      expect(@postTasks).not_to be_nil
      expect(@preliminaryTasks.select{|t| t.task_status == 'finished'}).not_to be_nil
      expect(@devTasks.select{|t| t.task_status == 'finished'}).not_to be_nil
      expect(@postTasks.select{|t| t.task_status == 'finished'}).not_to be_nil
      expect(@preliminaryTasks.select{|t| t.task_status == 'finished'}.count*1.0).to eq 1
      expect(@devTasks.select{|t| t.task_status == 'finished'}.count*1.0).to eq 2
      expect(@postTasks.select{|t| t.task_status == 'finished'}.count*1.0).to eq 0

      precount = @preliminaryTasks.select{|t| t.task_status == 'finished'}.count*1.0
      devcount = @devTasks.select{|t| t.task_status == 'finished'}.count*1.0
      postcount = @postTasks.select{|t| t.task_status == 'finished'}.count*1.0
      @prepercent, @devpercent, @postpercent = Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
      expect(@prepercent).to eq 50
      expect(@devpercent).to eq 100
      expect(@postpercent).to eq 0
    end

  end

  describe 'copy over the iteration' do
    before(:each) do
      @iteration = create(:iteration)
      @pretask1 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'finished')
      @pretask2 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'started')
      @devtask1 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @devtask2 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @posttask1 = create(:task, :post, iteration_id: @iteration.id, task_status:'danger')
      @posttask2 = create(:task, :post, iteration_id: @iteration.id, task_status:'started')
      testproj1 =  create(:project)
      testproj2 =  create(:project)
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'should copy the iteration' do
      newiter = Iteration.new()
      newiter.save
      expect(newiter).not_to eq nil
    end

    it 'can call the tasks' do
      tasks = Task.where(Iteration_id = @iteration.id)
      expect(tasks).to include @pretask1
    end

    it 'copy one task' do
      newt = Task.new
      newt.title = @pretask1.title
      newt.updater_type = @pretask1.updater_type
      newt.description = @pretask1.description
      newt.task_status = 'unstarted'
      newt.iteration_id = 2
      expect(newt.save).to be true
    end

    it 'should copy over the tasks' do
      newiter = Iteration.new()
      newiter.project_id = 1
      newiter.save
      expect(newiter.save).not_to be_nil
      tasks = Task.where(Iteration_id = @iteration.id)
      tasks.each do |task|
        newt = Task.new
        newt.title = task.title
        newt.updater_type = task.updater_type
        newt.description = task.description
        newt.task_status = 'unstarted'
        newt.iteration_id = newiter
        newt.save
        expect(newt.save).to be true
      end
      tasks.each do |task|
        expect(Task.where(iteration_id: newiter.id).where(title: task.title)).not_to be_nil
      end
    end

    it 'run the copy assignment function' do
      expect(Iteration.copy_assignment(@iteration,2)).not_to be_nil
    end

    it 'run the copy assignment function successfully' do
      newiter = Iteration.copy_assignment(@iteration,2)
      tasks = Task.where(Iteration_id = @iteration.id)
      tasks.each do |task|
        expect(Task.where(iteration_id: newiter.id).where(title: task.title)).not_to be_nil
      end
    end

    it 'run over a copy assignment all the existing projects' do
      expect(Iteration.all_copy_assignment @iteration).not_to be_nil
    end

    it 'run over a copy assignment all the existing projects with creating new iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        expect(iter).not_to be_nil
      end
    end

    it 'after assigning the new iteration to a tasks,they should all be active' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        expect(iter[0].active).to eq true
      end
    end

    it 'should only have at most one active iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id).where(active: true)
        expect(iter.length <= 1).to eq true
      end
    end

    it 'run over a copy assignment all the existing projects with creating new iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        @tasks.each do |task|
          expect(Task.where(iteration_id: iter[0].id).where(title: task.title)).not_to be_nil
        end
        expect(iter).not_to be_nil
      end
    end
  end

  describe 'present the progress of the assignment' do
    before(:each) do
      @testproj3 = create(:project)
      @iteration = create(:iteration, active: true, project_id: @testproj3.id)
      @pretask1 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'finished')
      @pretask2 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'started')
      @devtask1 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @devtask2 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @posttask1 = create(:task, :post, iteration_id: @iteration.id, task_status:'danger')
      @posttask2 = create(:task, :post, iteration_id: @iteration.id, task_status:'started')
      @testproj1 =  create(:project)
      @testproj2 =  create(:project)
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'find out the correct iteration belong to the iteration' do
      iter = Iteration.where(project_id: @testproj3.id).where(active: true).limit(1)
      expect(iter[0]).to eq @iteration
    end

    it 'count the number of tasks of each status  ' do
      tasks = Task.where(iteration_id: @iteration.id)
      expect(tasks.select{|t| t.task_status == "finished"}.count).to eq 3
      expect(tasks.select{|t| t.task_status == "danger"}.count).to eq 1
      expect(tasks.select{|t| t.task_status == "started"}.count).to eq 2
      expect(tasks.select{|t| t.task_status == "unstarted"}.count).to eq 0
    end

    it 'perform the function and return a list of each status' do
      expect(Iteration.count_graph_status @testproj3.id).to eq [3,1,2,0]
    end

    it 'perform the function and return false when there is no such project to be found' do
      expect(Iteration.count_graph_status @testproj1.id).to eq nil
    end

    it 'count the status of all the projects and return the hash' do
      expect(Iteration.task_progress).not_to be_nil
    end

    it 'count the status of all the projects and return the hash' do
      progress_hash = Iteration.task_progress
      expect(Project.all).to include(@testproj3)
      expect(Project.all).to include(@testproj1)
      expect(Project.all).to include(@testproj2)
      expect(progress_hash[@testproj3.id]).to eq [3,1,2,0]
      expect(progress_hash[@testproj1.id]).to eq nil
      expect(progress_hash[@testproj2.id]).to eq nil
    end

    it 'translate input string to datetime' do
      expect('2022/03/01'.split('/')).to eq ['2022','03','01']
      expect('31'.to_i).to eq 31
      expect(['2022','03','01'].map{|s| s.to_i}).to eq [2022,3,1]
      expect(('2022/03/01'.split('/')).map{|s| s.to_i}).to eq [2022,3,1]
    end

    it 'deal with the time stamp input and output' do
      itera = Iteration.new()
      starttime = DateTime.new([2022,03,01][0],[2022,03,01][1],[2022,03,01][2])
      endtime = DateTime.new(2001,4,3)
      itera.start_time = starttime
      expect(itera.save).to be true
      expect(itera.update_attribute(:end_time,endtime)).to be true
      expect(itera.end_time).to eq DateTime.new(2001,4,3)
    end

    it 'the function is corret' do
      iter = Iteration.new()
      iter.save
      start_time = '2022/03/01'
      end_time = '2023/03/01'
      iter = Iteration.find(iter.id)
      expect(iter.set_timestamp start_time, end_time).not_to be_nil
      expect(iter.start_time).to eq DateTime.new(2022,3,1)
      expect(iter.end_time).to eq DateTime.new(2023,3,1)
    end
  end

  describe 'Create iteration template and modify the tasks graph' do
    it 'create the iteration' do
      iter = Iteration.new
      iter.name = "new template"
      expect(iter.save).to be true
    end

    it 'create a template iteration to include tasks graph' do
      iter = Iteration.new
      iter.template = true
      iter.save
      expect(Iteration.where(template: true)).to include iter
    end

  end

end