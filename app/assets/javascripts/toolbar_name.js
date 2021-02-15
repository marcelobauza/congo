toolbar_name = function(m, drawControl){
    L.drawLocal = {
      draw: {
        toolbar: {
          actions: {
            title: 'Cancel drawing',
            text: 'Cancelar'
          },
          finish: {
            title: 'Finish drawing',
            text: 'Finalizar'
          },
          undo: {
            title: 'Delete last point drawn',
            text: 'Eliminar el último punto'
          },
          buttons: {
            marker: 'Punto',
            polygon: 'Polígono',
            circle: 'Radio',
          }
        },
        handlers: {
          circle: {
            tooltip: {
              start: 'Haga click en el mapa y arrastre para dibujar un círculo.'
            },
            radius: 'Radio'
          },
          circlemarker: {
            tooltip: {
              start: 'Click map to place circle marker.'
            }
          },
          marker: {
            tooltip: {
              start: 'Haga click en el mapa para seleccionar la comuna.'
            }
          },
          polygon: {
            tooltip: {
              start: 'Haga click para comenzar a dibujar el polígono.',
              cont: 'Haga click para continuar dibujando el polígono.',
              end: 'Haga click en el primer punto para cerrar este polígono.'
            }
          },
          polyline: {
            error: '<strong>Error:</strong> los bordes del polígono no pueden cruzarse.',
            tooltip: {
              start: 'Click to start drawing line.',
              cont: 'Click to continue drawing line.',
              end: 'Click last point to finish line.'
            }
          },
          rectangle: {
            tooltip: {
              start: 'Click and drag to draw rectangle.'
            }
          },
          simpleshape: {
            tooltip: {
              end: 'Suelte el mouse para terminar de dibujar.'
            }
          }
        }
      },
      edit: {
        toolbar: {
          actions: {
            save: {
              title: 'Save changes',
              text: 'Guardar'
            },
            cancel: {
              title: 'Cancel editing, discards all changes',
              text: 'Cancelar'
            },
            clearAll: {
              title: 'Clear all layers',
              text: 'Limpiar todo'
            }
          },
          buttons: {
            edit: 'Editar',
            editDisabled: 'Nada para editar',
          }
        },
        handlers: {
          edit: {
            tooltip: {
              text: 'Drag handles or markers to edit features.',
              subtext: 'Click cancel to undo changes.'
            }
          }
        }
      }
    };

    m.addControl(drawControl);
}
