// App.test.js
import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders learn react link', () => {
  render(<App />);
  const learnReactLink = screen.getByText(/learn react/i);
  expect(learnReactLink).toBeInTheDocument();
});
