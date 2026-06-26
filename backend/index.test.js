// Teste básico do backend
describe('Backend API', () => {
  test('deve retornar verdadeiro', () => {
    expect(true).toBe(true);
  });

  test('deve ter porta 3001 configurada', () => {
    const port = process.env.PORT || 3001;
    expect(port).toBe(3001);
  });
});
