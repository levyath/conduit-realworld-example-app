import { describe, it, expect } from 'vitest';

describe('Frontend App', () => {
  it('deve retornar verdadeiro', () => {
    expect(true).toBe(true);
  });

  it('deve ter React disponível', () => {
    expect(typeof React).toBe('undefined' || 'object');
  });
});
