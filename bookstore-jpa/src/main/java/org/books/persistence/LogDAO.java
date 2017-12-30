package org.books.persistence;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.books.data.Log;

@Stateless
@LocalBean
public class LogDAO {

	@PersistenceContext
	private EntityManager entityManager;

	public LogDAO() {
	}

	protected LogDAO(EntityManager entityManager) {
		this.entityManager = entityManager;
	}

	public Log persist(Log log) {
		entityManager.persist(log);
		entityManager.flush();
		return log;
	}
}
