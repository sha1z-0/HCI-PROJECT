export const errorHandler = (err, req, res, next) => {
  const status = err.status || 500;
  // Log full error on the server to aid debugging (stack, message, and any additional info)
  console.error('Unhandled error:', {
    message: err.message,
    stack: err.stack,
    ...(err.code ? { code: err.code } : {}),
  });

  res.status(status).json({
    message: err.message || 'Server error',
  });
};
