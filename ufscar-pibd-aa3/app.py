import streamlit as st
import psycopg2
import pandas as pd
import db

st.set_page_config(
    page_title="Portal do Aluno",
    layout="wide",
)

if "aluno" not in st.session_state:
    st.session_state.aluno = None


def tela_login():
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.title("Portal do Aluno")
        st.caption("Sistema de Gestão Acadêmica")
        st.divider()
        with st.form("form_login"):
            num_matricula = st.text_input("Número de Matrícula", placeholder="Ex: 2023001")
            entrar = st.form_submit_button("Entrar", use_container_width=True, type="primary")

        if entrar:
            if not num_matricula.strip():
                st.error("Informe o número de matrícula.")
            else:
                try:
                    aluno = db.buscar_aluno_por_matricula(num_matricula.strip())
                    if aluno:
                        st.session_state.aluno = aluno
                        st.rerun()
                    else:
                        st.error("Matrícula não encontrada.")
                except psycopg2.OperationalError:
                    st.error("Não foi possível conectar ao banco de dados. Verifique as configurações em db.py.")


STATUS_ICON = {
    "Ativa":      "🟢",
    "Aprovado":   "✅",
    "Reprovado":  "❌",
    "Trancada":   "🔒",
    "Cancelada":  "⛔",
}


def tela_minhas_turmas(id_aluno: int):
    st.header("Minhas Turmas")

    matriculas = db.buscar_matriculas_aluno(id_aluno)

    if not matriculas:
        st.info("Você ainda não possui matrículas.")
        return

    rows = []
    for m in matriculas:
        icon = STATUS_ICON.get(m["status"], "")
        rows.append({
            "Disciplina":  m["disciplina"],
            "Professor":   m["professor"],
            "Período":     m["periodo_letivo"],
            "Horários":    m["horarios"] or "—",
            "Nota":        f'{float(m["nota"]):.1f}'        if m["nota"]       is not None else "—",
            "Frequência":  f'{float(m["frequencia"]):.1f}%' if m["frequencia"] is not None else "—",
            "Status":      f'{icon} {m["status"]}',
        })

    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)

    ativas = [m for m in matriculas if m["status"] == "Ativa"]
    if not ativas:
        return

    st.divider()
    st.subheader("Trancar Matrícula")
    st.caption("Apenas matrículas com status Ativa podem ser trancadas.")

    opcoes = {
        f'{m["disciplina"]} — {m["codigo_turma"]} ({m["periodo_letivo"]})': m["id_turma"]
        for m in ativas
    }
    escolha = st.selectbox("Selecione a turma", list(opcoes.keys()), key="sel_trancar")

    if st.button("Trancar Matrícula", type="primary", key="btn_trancar"):
        try:
            db.trancar_matricula(id_aluno, opcoes[escolha])
            st.success("Matrícula trancada com sucesso.")
            st.rerun()
        except psycopg2.Error as e:
            msg = e.diag.message_primary if e.diag.message_primary else str(e)
            st.error(f"Erro: {msg}")


def tela_nova_matricula(id_aluno: int):
    st.header("Nova Matrícula")

    turmas = db.buscar_turmas_disponiveis(id_aluno)

    if not turmas:
        st.info("Não há turmas disponíveis com vagas para você no momento.")
        return

    rows = []
    for t in turmas:
        rows.append({
            "Disciplina": t["disciplina"],
            "CH (h)":     t["carga_horaria"],
            "Professor":  t["professor"],
            "Período":    t["periodo_letivo"],
            "Horários":   t["horarios"] or "—",
            "Vagas":      int(t["vagas_disponiveis"]),
        })

    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)

    st.divider()
    st.subheader("Solicitar Matrícula")

    opcoes = {
        f'{t["disciplina"]} — {t["codigo_turma"]} ({t["periodo_letivo"]}) · {int(t["vagas_disponiveis"])} vagas': t["id_turma"]
        for t in turmas
    }
    escolha = st.selectbox("Selecione a turma", list(opcoes.keys()), key="sel_matricular")

    if st.button("Confirmar Matrícula", type="primary", key="btn_matricular"):
        try:
            db.realizar_matricula(id_aluno, opcoes[escolha])
            st.success("Matrícula realizada com sucesso!")
            st.rerun()
        except psycopg2.Error as e:
            msg = e.diag.message_primary if e.diag.message_primary else str(e)
            st.error(f"Erro: {msg}")


def main():
    if st.session_state.aluno is None:
        tela_login()
        return

    aluno = st.session_state.aluno
    ira = db.calcular_ira(aluno["id_aluno"])

    with st.sidebar:
        st.title("🎓 Portal do Aluno")
        st.write(f"**{aluno['nome']}**")
        st.caption(aluno["nome_curso"])
        st.metric("IRA", f"{float(ira):.2f}" if ira else "—")
        st.divider()
        pagina = st.radio(
            "Navegação",
            ["Minhas Turmas", "Nova Matrícula"],
            label_visibility="collapsed",
        )
        st.divider()
        if st.button("Sair", use_container_width=True):
            st.session_state.aluno = None
            st.rerun()

    if pagina == "Minhas Turmas":
        tela_minhas_turmas(aluno["id_aluno"])
    else:
        tela_nova_matricula(aluno["id_aluno"])


main()
