class TestApp

  def call(env)
    [200, {'Content-Type' => 'text/html'}, ['This is the test1 branch']]
  end
end
