from threading import Timer


class RepeatedTimer(object):
  def __init__(self, function, *args, **kwargs):
    self._timer = None
    self._running = False
    self.function = function
    self.args = args
    self.kwargs = kwargs

  @property
  def running(self):
    return self._running

  def _run(self):
    self._running = False
    self.start(self._interval)
    self.function(*self.args, **self.kwargs)

  def start(self, interval: int):
    if not self._running:
      self._interval = interval
      self._timer = Timer(interval, self._run)
      self._timer.start()
      self._running = True

  def stop(self):
    self._timer.cancel()
    self._running = False
