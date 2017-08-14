# TODO: Fix when jasmine-rails has been patched
# Do not run Jasmine tests on CI as they break Minitest
# https://github.com/searls/jasmine-rails/issues/213
# Rake::Task[:default].enhance ['spec:javascript']
