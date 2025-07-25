document.addEventListener("DOMContentLoaded", function () {
  // Gráfico de Leads por Conjunto
  const graficoConjuntos = document.getElementById("graficoConjuntos");
  if (graficoConjuntos) {
    new Chart(graficoConjuntos, {
      type: 'pie',
      data: {
        labels: window.labelsConjuntos || [],
        datasets: [{
          data: window.valoresConjuntos || [],
          backgroundColor: ['#007bff', '#3399ff', '#66b3ff', '#5dade2', '#2980b9']
        }]
      }
    });
  }

  // Gráfico de Leads por Corretor
  const graficoCorretores = document.getElementById("graficoCorretores");
  if (graficoCorretores) {
    new Chart(graficoCorretores, {
      type: 'bar',
      data: {
        labels: window.labelsCorretores || [],
        datasets: [{
          label: 'Leads',
          data: window.valoresCorretores || [],
          backgroundColor: '#0d6efd'
        }]
      },
      options: {
        indexAxis: 'y',
        scales: {
          x: {
            beginAtZero: true
          }
        }
      }
    });
  }

  // Inicialização do DataTable
  const tabelaLeads = document.getElementsByClassName("datatables");
  if (tabelaLeads) {
    $(tabelaLeads).DataTable({
      responsive: true,
      pageLength: 10,
      language: {
        url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/pt-BR.json'
      }
    });
  }
});
