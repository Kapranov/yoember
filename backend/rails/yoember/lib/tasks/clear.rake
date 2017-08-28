namespace :clear do
  desc "LOG TMP CLEAR| Clear all temporary files"
  task clear: 'all'
  task tmp: 'tmp:clear'
  task log: 'log:clear'
  task all: [:tmp,:log]
end
