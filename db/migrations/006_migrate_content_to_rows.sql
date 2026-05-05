-- ============================================================
-- 006: Migrate page content from sections to rows format
-- Transforms home, nosotros, contacto pages to PageBuilder rows
-- ============================================================

UPDATE pages SET content = $json$
{
  "rows": [
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "sm",
      "fullWidth": true,
      "columns": [
        {
          "width": "",
          "widgets": [
            {
              "type": "hero",
              "slides": [
                {
                  "image": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=1400&h=600&fit=crop",
                  "title": "BIENVENIDOS A ONG ANDES SUR",
                  "subtitle": "Biodiversidad, desarrollo sostenible y ayuda solidaria en el sur del Perú.",
                  "button": {"text": "Conoce más", "link": "/nosotros"}
                },
                {
                  "image": "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=1400&h=600&fit=crop",
                  "title": "PROYECTOS DE DESARROLLO",
                  "subtitle": "Comprometidos con el desarrollo del sur, la educación y el medio ambiente.",
                  "button": {"text": "Ver proyectos", "link": "/proyectos"}
                },
                {
                  "image": "https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=1400&h=600&fit=crop",
                  "title": "SERVICIOS PROFESIONALES",
                  "subtitle": "Asesoría de tesis, gestión empresarial y consultoría pública.",
                  "button": {"text": "Ver servicios", "link": "/servicios"}
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "sm",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "divider", "style": "wave"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "BIENVENIDOS A ONG ANDES SUR", "tag": "h2"},
            {"type": "text", "content": "<p class=\"text-center max-w-3xl mx-auto\">ONG ANDES SUR trabaja constantemente en biodiversidad y ayuda solidaria a niños y jóvenes que necesiten de nosotros. Además promovemos el intercambio horizontal de experiencias de la mano preservando el medio ambiente utilizando las 6R's que son reducir, reutilizar, reciclar, redistribuir, reparar y reflexionar.</p>"},
            {"type": "button", "text": "Más información", "link": "/nosotros", "style": "secondary"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=400&h=300&fit=crop", "alt": "Proyectos", "class": "rounded-xl w-full h-48 object-cover"},
            {"type": "title", "content": "PROYECTOS", "tag": "h3"},
            {"type": "text", "content": "<p>Nuestros ejes de desarrollo son tres: investigación y desarrollo, gestión empresarial y pública para el desarrollo sostenible y extensión en el ámbito socio-cultural.</p>"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=400&h=300&fit=crop", "alt": "Clientes", "class": "rounded-xl w-full h-48 object-cover"},
            {"type": "title", "content": "CLIENTES", "tag": "h3"},
            {"type": "text", "content": "<p>Nuestros servicios van dirigidos tanto a la pequeña y mediana empresa, como también a aquellas personas que desean realizar investigación, ya sea para obtener un grado académico o bien para publicar en revistas científicas.</p>"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400&h=300&fit=crop", "alt": "Servicios", "class": "rounded-xl w-full h-48 object-cover"},
            {"type": "title", "content": "SERVICIOS", "tag": "h3"},
            {"type": "text", "content": "<p>Asesoría de tesis en Ciencias Sociales, Asesoría en Gestión Empresarial, Consultoría en proyectos del sector público.</p>"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "center", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "70",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400&h=300&fit=crop", "alt": "Desarrollo del sur", "class": "rounded-lg -rotate-3 max-w-xs"}
          ]
        },
        {
          "width": "30",
          "widgets": [
            {"type": "title", "content": "Comprometidos con el desarrollo del sur", "tag": "h3"},
            {"type": "text", "content": "<p>La pandemia del COVID-19 ha generado un cambio en las actividades que el hombre desarrolla con normalidad como acudir a su centro de estudios. Conoce más de nuestros proyectos.</p>"},
            {"type": "button", "text": "Ver Proyectos", "link": "/proyectos", "style": "secondary"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "services"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "products"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "news"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "#ba9774", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "center", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "<span style=\"color:white\">Pronto nuestros artículos de opinión</span>", "tag": "h2"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "center", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "🤓 Necesitas ayuda con tu tesis?", "tag": "h3"},
            {"type": "button", "text": "Nos comunicamos contigo", "link": "/contacto", "style": "primary"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=300&h=400&fit=crop", "alt": "Ayuda tesis", "class": "max-w-xs rounded-lg"}
          ]
        }
      ]
    }
  ]
}
$json$::jsonb WHERE slug = 'home';

UPDATE pages SET content = $json$
{
  "rows": [
    {
      "background": {"image": "https://images.unsplash.com/photo-1526976668912-1a811818c6df?w=1200&h=300&fit=crop", "color": "", "overlay": 0.4, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "center", "horizontal": "center"},
      "padding": "xl",
      "fullWidth": true,
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "<span style=\"color:white;text-shadow:4px 4px 3px rgba(172,165,11,0.78)\">Nosotros</span>", "tag": "h1"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "Misión", "tag": "h3"},
            {"type": "text", "content": "<p>Desarrollar competencias y apoyar el aprovechamiento de oportunidades de las poblaciones más vulnerables a través de un trabajo conjunto con entidades públicas y privadas.</p>"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "Visión", "tag": "h3"},
            {"type": "text", "content": "<p>Ser una organización referente en el campo del desarrollo económico y social sostenible que aspira a una sociedad más justa.</p>"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "NUESTRO EQUIPO", "tag": "h2"},
            {"type": "text", "content": "<p class=\"text-center\">CONTAMOS CON UN STAFF DE PROFESIONALES Y VOLUNTARIOS UNIVERSITARIOS DE PRIMER NIVEL</p>"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&h=200&fit=crop&crop=face", "alt": "Anatolia Hinojosa", "class": "w-32 h-32 rounded-full object-cover mx-auto mb-2"},
            {"type": "title", "content": "Directora Ejecutiva: Dr. Anatolia Hortencia Hinojosa Pérez", "tag": "h4"},
            {"type": "text", "content": "<p class=\"text-sm\">Titulo Profesional como Economista otorgado por la Universidad Católica Santa María, con Maestría en Gestión Social y Desarrollo Sostenible de la Universidad Nacional San Agustín, ESAN - Participación en Programa de Capacitación PIP: Fortalecimiento y Desarrollo de Capacidades Nacionales en Evaluación y Valoración Económica del Patrimonio Natural.</p>"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&h=200&fit=crop&crop=face", "alt": "Ingrid Pastor", "class": "w-32 h-32 rounded-full object-cover mx-auto mb-2"},
            {"type": "title", "content": "Directora de Relaciones Internacionales: Dra. Ingrid Pastor de Jones", "tag": "h4"},
            {"type": "text", "content": "<p class=\"text-sm\">Doctora en Educación, Magister en Tecnología Educativa; Segunda Especialización en Filosofía Católica; Licenciada en Educación Secundaria Especialidad: Lengua, Literatura y Filosofía y Bachiller en Ciencias de la Educación por la Universidad Católica Santa María y Profesora de Educación Secundaria en la especialidad de Idiomas francés, inglés en el Instituto Pedagógico Arequipa.</p>"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face", "alt": "José Hinojosa", "class": "w-32 h-32 rounded-full object-cover mx-auto mb-2"},
            {"type": "title", "content": "Director de Proyectos: José Adolfo Hinojosa Pérez", "tag": "h4"},
            {"type": "text", "content": "<p class=\"text-sm\">Doctor en Economía por la Universidad de París VIII, París Francia. Experiencia en participación en investigación y publicación de libros y artículos de revistas especializadas.</p>"}
          ]
        }
      ]
    }
  ]
}
$json$::jsonb WHERE slug = 'nosotros';

UPDATE pages SET content = $json$
{
  "rows": [
    {
      "background": {"image": "https://images.unsplash.com/photo-1423666639041-f56000c27a9a?w=1200&h=300&fit=crop", "color": "", "overlay": 0.4, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "center", "horizontal": "center"},
      "padding": "xl",
      "fullWidth": true,
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "<span style=\"color:white;text-shadow:4px 4px 3px rgba(172,165,11,0.78)\">Contacto</span>", "tag": "h1"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "Información de contacto", "tag": "h3"},
            {"type": "text", "content": "<p><strong>Dirección</strong></p><p>Arequipa, Perú</p><p class=\"mt-4\"><strong>Email</strong></p><p>ongandessur@gmail.com</p>"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "Envíanos un mensaje", "tag": "h3"},
            {"type": "text", "content": "<p>Puedes escribirnos a <a href=\"mailto:ongandessur@gmail.com\" class=\"text-brand-teal font-semibold\">ongandessur@gmail.com</a> o visitarnos en Arequipa.</p>"}
          ]
        }
      ]
    }
  ]
}
$json$::jsonb WHERE slug = 'contacto';

UPDATE pages SET content = $json$
{
  "rows": [
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "PROYECTOS POR DESARROLLAR", "tag": "h2", "textAlign": "center"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200&h=200&fit=crop", "alt": "Adopta un pueblo", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "ADOPTA UN PUEBLO", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">Con la finalidad de generar desarrollo sostenible, buscamos encontrar socios que estén dispuestos a apoyar proyectos en los pueblos interandinos que permitan elevar la productividad, la innovación para mejorar la calidad de vida de los pobladores.</p>", "textAlign": "center"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=200&h=200&fit=crop", "alt": "Plogging", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "PLOGGING RECOGE, CORRE Y AYUDA AL MEDIO AMBIENTE", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">Salir a correr ya no es sólo preparar las zapatillas y la ropa. Ahora también podremos llevar un par de guantes de látex, una bolsa de basura y muchas ganas de hacer ejercicio pero también de colaborar con el medio ambiente y la limpieza. Así nació el Plogging, una tendencia que arrancó en Suecia y replicaremos en la Ciudad Blanca.</p>", "textAlign": "center"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=200&h=200&fit=crop", "alt": "Marketing de guerrilla", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "MARKETING DE GUERRILLA", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">Herramienta de gran valor que utilizaremos para potencializar la comunicación entre el Estado, la empresa, la academia y la sociedad civil con la finalidad de generar cambios sociales y generar conciencia con el cuidado del medio ambiente.</p>", "textAlign": "center"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "PROYECTOS EN DESARROLLO", "tag": "h2", "textAlign": "center"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200&h=200&fit=crop", "alt": "Tableta para tu carpeta", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "TABLETA PARA TU CARPETA", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">La pandemia del COVID-19 ha generado un cambio en las actividades que el hombre desarrolla con normalidad como acudir a su centro de estudios. En nuestro país, muchos estudiantes han tenido que adaptarse a esa nueva normalidad como lo son las clases virtuales. Los estudiantes que no tengan acceso a algún dispositivo electrónico para acceder a sus clases, se verán afectados por no tener los medios necesarios para continuar con vida académica. Promover el acceso a la educación virtual mediante un dispositivo electrónico que permita a estudiantes en situación vulnerable continuar con su formación académica.</p>", "textAlign": "center"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "center"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "title", "content": "PROYECTOS REALIZADOS", "tag": "h2", "textAlign": "center"}
          ]
        }
      ]
    },
    {
      "background": {"image": "", "color": "", "overlay": 0, "position": "center", "repeat": "no-repeat", "size": "cover"},
      "alignment": {"vertical": "flex-start", "horizontal": "flex-start"},
      "padding": "lg",
      "columns": [
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=200&h=200&fit=crop", "alt": "Convenio Piecess", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "CONVENIO FUNDACIÓN PIECES - UNIVERSIDAD SAN GALLENT DE SUIZA", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">Se ha concretado la alianza con la Fundación Pieces - Universidad de San Galen de Suiza, para realizar un proyecto de cooperación en la enseñanza de inglés, que se realiza 2 veces al año de manera gratuita a niños del orfanato Chávez de la Rosa, Centro de Familia de Cayma, alumnos de Beca 18, en Arequipa. Este curso lo imparten estudiantes voluntarios de esta prestigiosa Universidad de Suiza, a partir del 2016 al 2018.</p>", "textAlign": "center"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=200&h=200&fit=crop", "alt": "Plan estratégico Mungui", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "PLAN ESTRATÉGICO DE MUNGUI CAPITAL DEL DISTRITO DE PAMPAMARCA", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">Entregado al presidente de la comunidad el Documento que incluye la visión, misión, los objetivos, las metas, las estrategias y actividades para el desarrollo de Mungui capital del distrito de Pampamarca.</p>", "textAlign": "center"}
          ]
        },
        {
          "width": "",
          "widgets": [
            {"type": "image", "src": "https://images.unsplash.com/photo-1576610616656-d3aa88d1f0cf?w=200&h=200&fit=crop", "alt": "Remodelación piscina Mungui", "class": "w-full h-48 object-cover rounded-xl mb-2"},
            {"type": "title", "content": "REMODELACIÓN DE LA PISCINA DEL PUEBLO DE MUNGUI", "tag": "h3", "textAlign": "center"},
            {"type": "text", "content": "<p class=\"text-sm\">Se ha desarrollado el proyecto de arquitectura para la remodelación de la piscina de Mungui, que estuvo abandonada 30 años para su puesta en valor con la participación de la Municipalidad Provincial de La Unión, distrital de Pampamarca, la comunidad y la sociedad civil representados por los residentes naturales de este distrito en Arequipa y Lima.</p>", "textAlign": "center"}
          ]
        }
      ]
    }
  ]
}
$json$::jsonb WHERE slug = 'proyectos';
