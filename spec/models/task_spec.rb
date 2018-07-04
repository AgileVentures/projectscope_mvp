require 'rails_helper'

describe Task do
  before(:each) do
    @iteration = create(:iteration)
    @github_task = create(:task, :github, iteration_id: @iteration.id)
    @local_task = create(:task, :local, iteration_id: @iteration.id)
    @cm_task = create(:task, :preliminary, iteration_id: @iteration.id, title: 'Customer Meeting')
    @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    @danger_task = create(:task, :pivotal, iteration_id: @iteration.id, task_status:'danger')
  end

  describe 'create three types of tasks' do

    it {expect(@github_task.iteration_id).to be @iteration.id}
    it {expect(@local_task).not_to be_nil}
    it {expect(@pivotal_task).not_to be_nil}

    it 'contains all task' do
      tasks = Task.where(iteration: @iteration.id)
      expect(tasks).to include(@github_task)
      expect(tasks).to include(@pivotal_task)
      expect(tasks).to include(@local_task)
    end
  end

  describe 'iterate through task and update' do
    before(:each) do
      @tasks = Task.where(iteration: @iteration.id)
    end
    it 'task with status started should be updatable' do
      expect(@local_task.updatable?).to be(true)
    end

    it 'task with status danger should be able to udpate' do
      expect(@danger_task.task_status).to eq('danger')
      expect(@danger_task.updatable?).to be (true)
    end

    it 'receive event hash and iterate itself' do
      expect(Task.tasks_update_all(@tasks, "customer meeting", "true")).not_to be_nil
    end

    it 'the iterate function is going to update the key and value of certain task' do
      Task.tasks_update_all(@tasks, "Customer Meeting", "true")
      task = Task.find_by_title("Customer Meeting")
      expect(task.task_status).to eq('finished')
    end

    it 'update each task' do
      expect(@cm_task.update_status("Customer Meeting","true")).not_to be_nil
    end

    it 'successfully update the task' do
      @cm_task.update_status("Customer Meeting","true")
      task = Task.find_by_title('Customer Meeting')
      expect(task.task_status).to eq('finished')
    end



  end

  describe 'update the task when reach requirement' do
    skip
  end

  describe 'update only started' do
    skip
  end

  describe 'danger when possibly unable to finish task' do
    skip
  end


  describe 'start task when only if parent task finished' do
    skip
  end

  describe 'github update' do
    skip
  end

  describe 'pivotal update' do
    skip
  end

  describe 'local update' do
    skip
  end
end