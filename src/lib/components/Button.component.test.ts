import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/svelte';
import { Button } from './Button.svelte';

describe('Button Component', () => {
  it('renders button with text', () => {
    render(Button, { props: { text: 'Click me' } });
    
    expect(screen.getByRole('button')).toBeInTheDocument();
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('handles click events', async () => {
    let clicked = false;
    const handleClick = () => { clicked = true; };
    
    render(Button, { 
      props: { 
        text: 'Click me',
        onClick: handleClick
      } 
    });
    
    await screen.getByRole('button').click();
    expect(clicked).toBe(true);
  });
});
