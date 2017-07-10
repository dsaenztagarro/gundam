require 'spec_helper'

describe Gundam::ContextProvider do
  describe '#load_context' do
    context 'when base dir is not a repo' do
      it 'raises an exception' do
        Dir.mktmpdir do |dir|
          expect { subject.load_context(base_dir: dir) }.to raise_error(Gundam::LocalRepoNotFound)
        end
      end
    end
  end
end
