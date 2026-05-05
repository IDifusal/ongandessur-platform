-- ============================================================
-- Seeder: Initial page content (full version)
-- Run this after migrations to populate all default pages.
-- Idempotent: uses UPDATE for existing rows, INSERT for new.
-- ============================================================

-- Helper: insert or update
create or replace function seed_page(p_slug text, p_title text, p_content jsonb) returns void as $$
begin
  insert into public.pages (slug, title, content, published_at)
  values (p_slug, p_title, p_content, now())
  on conflict (slug) do update set
    title = excluded.title,
    content = excluded.content,
    published_at = now(),
    updated_at = now();
end;
$$ language plpgsql;

-- ============================================================
-- HOME
-- ============================================================
select seed_page('home', 'Inicio', '{
  "sections": [
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
    },
    { "type": "wave" },
    {
      "type": "welcome",
      "class": "-mt-16 md:-mt-8",
      "title": "BIENVENIDOS A ONG ANDES SUR",
      "text": "ONG ANDES SUR trabaja constantemente en biodiversidad y ayuda solidaria a niños y jóvenes que necesiten de nosotros. Además promovemos el intercambio horizontal de experiencias de la mano preservando el medio ambiente utilizando las 6R''s que son reducir, reutilizar, reciclar, redistribuir, reparar y reflexionar.",
      "button": { "text": "Más información", "link": "/nosotros" }
    },
    {
      "type": "cards_grid",
      "cards": [
        { "title": "PROYECTOS", "image": "https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=400&h=300&fit=crop", "content": "Nuestros ejes de desarrollo son tres: investigación y desarrollo, gestión empresarial y pública para el desarrollo sostenible y extensión en el ámbito socio-cultural." },
        { "title": "CLIENTES", "image": "https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=400&h=300&fit=crop", "content": "Nuestros servicios van dirigidos tanto a la pequeña y mediana empresa, como también a aquellas personas que desean realizar investigación, ya sea para obtener un grado académico o bien para publicar en revistas científicas." },
        { "title": "SERVICIOS", "image": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400&h=300&fit=crop", "content": "Asesoría de tesis en Ciencias Sociales, Asesoría en Gestión Empresarial, Consultoría en proyectos del sector público." }
      ]
    },
    {
      "type": "text_image",
      "image": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400&h=300&fit=crop",
      "imageClass": "-rotate-3",
      "title": "Comprometidos con el desarrollo del sur",
      "text": "La pandemia del COVID-19 ha generado un cambio en las actividades que el hombre desarrolla con normalidad como acudir a su centro de estudios. Conoce más de nuestros proyectos.",
      "button": { "text": "Ver Proyectos", "link": "/proyectos" }
    },
    { "type": "dynamic_services" },
    { "type": "dynamic_products" },
    { "type": "dynamic_news" },
    {
      "type": "cta_banner",
      "text": "Pronto nuestros artículos de opinión"
    },
    {
      "type": "cta_image",
      "title": "🤓 Necesitas ayuda con tu tesis?",
      "image": "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=300&h=400&fit=crop",
      "button": { "text": "Nos comunicamos contigo", "link": "/contacto" }
    }
  ]
}');

-- ============================================================
-- NOSOTROS
-- ============================================================
select seed_page('nosotros', 'Nosotros', '{
  "sections": [
    {
      "type": "cover",
      "title": "Nosotros",
      "image": "https://images.unsplash.com/photo-1526976668912-1a811818c6df?w=1200&h=300&fit=crop",
      "titleStyle": "text-shadow: 4px 4px 3px rgba(172, 165, 11, 0.78);"
    },
    {
      "type": "mission_vision",
      "items": [
        { "title": "Misión", "text": "Desarrollar competencias y apoyar el aprovechamiento de oportunidades de las poblaciones más vulnerables a través de un trabajo conjunto con entidades públicas y privadas." },
        { "title": "Visión", "text": "Ser una organización referente en el campo del desarrollo económico y social sostenible que aspira a una sociedad más justa." }
      ]
    },
    {
      "type": "team",
      "title": "NUESTRO EQUIPO",
      "subtitle": "CONTAMOS CON UN STAFF DE PROFESIONALES <br />Y VOLUNTARIOS UNIVERSITARIOS DE PRIMER NIVEL",
      "members": [
        {
          "name": "Directora Ejecutiva: Dr. Anatolia Hortencia Hinojosa Pérez",
          "image": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&h=200&fit=crop&crop=face",
          "bio": "Titulo Profesional como Economista otorgado por la Universidad Católica Santa María, con Maestría en Gestión Social y Desarrollo Sostenible de la Universidad Nacional San Agustín, ESAN - Participación en Programa de Capacitación PIP: Fortalecimiento y Desarrollo de Capacidades Nacionales en Evaluación y Valoración Económica del Patrimonio Natural."
        },
        {
          "name": "Directora de Relaciones Internacionales: Dra. Ingrid Pastor de Jones",
          "image": "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&h=200&fit=crop&crop=face",
          "bio": "Doctora en Educación, Magister en Tecnología Educativa; Segunda Especialización en Filosofía Católica; Licenciada en Educación Secundaria Especialidad: Lengua, Literatura y Filosofía y Bachiller en Ciencias de la Educación por la Universidad Católica Santa María y Profesora de Educación Secundaria en la especialidad de Idiomas francés, inglés en el Instituto Pedagógico Arequipa."
        },
        {
          "name": "Director de Proyectos: José Adolfo Hinojosa Pérez",
          "image": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face",
          "bio": "Doctor en Economía por la Universidad de París VIII, París Francia. Experiencia en participación en investigación y publicación de libros y artículos de revistas especializadas."
        }
      ]
    }
  ]
}');

-- ============================================================
-- PROYECTOS
-- ============================================================
select seed_page('proyectos', 'Proyectos', '{
  "sections": [
    {
      "type": "project_cards",
      "title": "PROYECTOS POR DESARROLLAR",
      "items": [
        { "title": "ADOPTA UN PUEBLO", "image": "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200&h=200&fit=crop", "description": "Con la finalidad de generar desarrollo sostenible, buscamos encontrar socios que estén dispuestos a apoyar proyectos en los pueblos interandinos que permitan elevar la productividad, la innovación para mejorar la calidad de vida de los pobladores." },
        { "title": "PLOGGING ''RECOGE, CORRE Y AYUDA AL MEDIO AMBIENTE''", "image": "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=200&h=200&fit=crop", "description": "Salir a correr ya no es sólo preparar las zapatillas y la ropa. Ahora también podremos llevar un par de guantes de látex, una bolsa de basura y muchas ganas de hacer ejercicio pero también de colaborar con el medio ambiente y la limpieza. Así nació el Plogging, una tendencia que arrancó en Suecia y replicaremos en la Ciudad Blanca." },
        { "title": "MARKETING DE GUERRILLA", "image": "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=200&h=200&fit=crop", "description": "Herramienta de gran valor que utilizaremos para potencializar la comunicación entre el Estado, la empresa, la academia y la sociedad civil con la finalidad de generar cambios sociales y generar conciencia con el cuidado del medio ambiente." }
      ]
    },
    {
      "type": "project_cards",
      "title": "PROYECTOS EN DESARROLLO",
      "items": [
        { "title": "TABLETA PARA TU CARPETA", "image": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200&h=200&fit=crop", "description": "La pandemia del COVID-19 ha generado un cambio en las actividades que el hombre desarrolla con normalidad como acudir a su centro de estudios. En nuestro país, muchos estudiantes han tenido que adaptarse a esa nueva normalidad como lo son las clases virtuales. Los estudiantes que no tengan acceso a algún dispositivo electrónico para acceder a sus clases, se verán afectados por no tener los medios necesarios para continuar con vida académica. Promover el acceso a la educación virtual mediante un dispositivo electrónico que permita a estudiantes en situación vulnerable continuar con su formación académica." }
      ]
    },
    {
      "type": "project_cards",
      "title": "PROYECTOS REALIZADOS",
      "items": [
        { "title": "CONVENIO FUNDACIÓN PIECES - UNIVERSIDAD SAN GALLENT DE SUIZA", "image": "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=200&h=200&fit=crop", "description": "Se ha concretado la alianza con la Fundación Pieces - Universidad de San Galen de Suiza, para realizar un proyecto de cooperación en la enseñanza de inglés, que se realiza 2 veces al año de manera gratuita a niños del orfanato Chávez de la Rosa, Centro de Familia de Cayma, alumnos de Beca 18, en Arequipa. Este curso lo imparten estudiantes voluntarios de esta prestigiosa Universidad de Suiza, a partir del 2016 al 2018." },
        { "title": "PLAN ESTRATÉGICO DE MUNGUI CAPITAL DEL DISTRITO DE PAMPAMARCA", "image": "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=200&h=200&fit=crop", "description": "Entregado al presidente de la comunidad el Documento que incluye la visión, misión, los objetivos, las metas, las estrategias y actividades para el desarrollo de Mungui capital del distrito de Pampamarca." },
        { "title": "REMODELACIÓN DE LA PISCINA DEL PUEBLO DE MUNGUI", "image": "https://images.unsplash.com/photo-1576610616656-d3aa88d1f0cf?w=200&h=200&fit=crop", "description": "Se ha desarrollado el proyecto de arquitectura para la remodelación de la piscina de Mungui, que estuvo abandonada 30 años para su puesta en valor con la participación de la Municipalidad Provincial de La Unión, distrital de Pampamarca, la comunidad y la sociedad civil representados por los residentes naturales de este distrito en Arequipa y Lima." }
      ]
    }
  ]
}');

-- ============================================================
-- SERVICIOS
-- ============================================================
select seed_page('servicios', 'Servicios', '{
  "sections": [
    {
      "type": "service_cards",
      "title": "SERVICIOS",
      "items": [
        { "title": "Asesoría de Tesis", "image": "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=500&h=300&fit=crop", "description": "Por lo cual se ofrece el servicio de asesoría en: Plan de Tesis, Informe final de la investigación, Asesorías de tesis por etapas: Recolección de información, Planteamiento del problema, Marco teórico, Hipótesis, Metodología, Análisis de Resultados, Conclusiones y recomendaciones, Anexos." },
        { "title": "Asesoría en Gestión Empresarial", "image": "https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500&h=300&fit=crop", "description": "ONG Andessur realiza asesorías en Gestión empresarial para MIPYMES, en sus diferentes áreas empresariales: Gestión Administrativa, Recursos Humanos, Gestión Financiera, Logística, Marketing y redes sociales, Desarrollo y proceso de producto/servicio, Área Legal." },
        { "title": "Asesoría en Gestión Pública", "image": "https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=500&h=300&fit=crop", "description": "Dada la experiencia precedida de la ONG Andessur, realiza consultoría y asesoramiento para desarrollar y llevar a cabo proyectos para el sector público (Municipalidades locales y distritales)." }
      ]
    }
  ]
}');

-- ============================================================
-- CONTACTO
-- ============================================================
select seed_page('contacto', 'Contacto', '{
  "sections": [
    {
      "type": "cover",
      "title": "Contacto",
      "image": "https://images.unsplash.com/photo-1423666639041-f56000c27a9a?w=1200&h=300&fit=crop",
      "titleStyle": "text-shadow: 4px 4px 3px rgba(172, 165, 11, 0.78);"
    },
    {
      "type": "raw_html",
      "html": "<div class=\"max-w-3xl mx-auto py-12 grid grid-cols-1 md:grid-cols-2 gap-8\"><div><h2 class=\"text-2xl font-bold font-kadwa text-gray-800 mb-4\">Información de contacto</h2><div class=\"space-y-4\"><div><p class=\"font-semibold text-gray-700\">📍 Dirección</p><p class=\"text-gray-600\">Arequipa, Perú</p></div><div><p class=\"font-semibold text-gray-700\">📧 Email</p><p class=\"text-gray-600\">ongandessur@gmail.com</p></div></div></div><div><h2 class=\"text-2xl font-bold font-kadwa text-gray-800 mb-4\">Envíanos un mensaje</h2><p class=\"text-gray-600 mb-4\">Puedes escribirnos a <a href=\"mailto:ongandessur@gmail.com\" class=\"text-brand-teal font-semibold\">ongandessur@gmail.com</a> o visitarnos en Arequipa.</p></div></div>"
    }
  ]
}');

drop function seed_page;
