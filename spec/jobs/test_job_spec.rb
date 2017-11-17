# frozen_string_literal: true

require "rails_helper"

describe TestJob, type: :job do
  subject(:job) { described_class.perform_now(**params) }
  let(:params) { {} }

  context "when works ok" do
    it { expect { subject } .to change { ActiveJobReporter::Job.count } .by(1) }
    it { expect { subject } .to change { ActiveJobReporter::JobMessage.count } .by(1) }

    context "created job" do
      subject(:job_record) { ActiveJobReporter::Job.last }
      before { job }

      it { is_expected.to be_finished }
      it { expect(subject.result).to eq("ok") }
      it { expect(subject.user).to be_nil }
    end
  end

  context "when result is an error" do
    let(:params) { { error: true } }
    it { expect { subject } .to change { ActiveJobReporter::Job.count } .by(1) }
    it { expect { subject } .to change { ActiveJobReporter::JobMessage.count } .by(2) }

    context "created job" do
      subject(:job_record) { ActiveJobReporter::Job.last }
      before { job }

      it { is_expected.to be_finished }
      it { expect(subject.result).to eq("error") }
    end
  end

  context "when raises an error " do
    let(:params) { { raise: true } }
    it { expect { subject }.to raise_error }
    it { expect { subject rescue nil } .to change { ActiveJobReporter::Job.count } .by(1) }
    it { expect { subject rescue nil } .to change { ActiveJobReporter::JobMessage.count } .by(1) }

    context "created job" do
      subject(:job_record) { ActiveJobReporter::Job.last }
      before { job rescue nil }

      it { is_expected.to be_finished }
      it { expect(subject.result).to eq("error") }
    end
  end

  context "enqueued job" do
    subject(:job) { described_class.perform_later(**params) }

    it { expect { subject } .to change { ActiveJobReporter::Job.count } .by(1) }

    context "created job" do
      subject(:job_record) { ActiveJobReporter::Job.last }
      before { job }

      it { is_expected.to be_enqueued }
      it { expect(subject.result).to be_nil }
    end
  end

  context "with an admin user related" do
    let(:params) { { admin_user: user } }
    let(:user) { User.new(name: "Cuqui") }
    it { expect { subject } .to change { ActiveJobReporter::Job.count } .by(1) }
    it { expect { subject } .to change { ActiveJobReporter::JobMessage.count } .by(1) }

    context "created job" do
      subject(:job_record) { ActiveJobReporter::Job.last }
      before { job }

      it { is_expected.to be_finished }
      it { expect(subject.result).to eq("ok") }
      it { expect(subject.user).to eq(user) }
    end
  end

  context "with related objects" do
    let(:params) { { related: [resource1, resource2] } }
    let(:resource1) { Resource.new name: "super-res" }
    let(:resource2) { Resource.new name: "mega-res" }
    it { expect { subject } .to change { ActiveJobReporter::Job.count } .by(1) }
    it { expect { subject } .to change { ActiveJobReporter::JobMessage.count } .by(1) }

    context "created job" do
      subject(:job_record) { ActiveJobReporter::Job.last }
      before { job }

      it { is_expected.to be_finished }
      it { expect(subject.result).to eq("ok") }
      it { expect(subject.job_objects.map(&:object)).to contain_exactly(resource1, resource2) }
    end
  end
end
