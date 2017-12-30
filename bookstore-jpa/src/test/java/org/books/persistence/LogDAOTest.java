package org.books.persistence;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import org.books.data.Log;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import static org.testng.Assert.assertNotNull;

public class LogDAOTest {

	private static final String PERSISTENCE_UNIT = "test";

	private static EntityManagerFactory entityManagerFactory;
	private static EntityManager entityManager;
	private static EntityTransaction transaction;
	private static LogDAO logDAO;

	@BeforeClass
	public void createDAO() throws Exception {
		entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT);
		entityManager = entityManagerFactory.createEntityManager();
		transaction = entityManager.getTransaction();
		logDAO = new LogDAO(entityManager);
	}

	@Test
	public void persistLog() {
		transaction.begin();
		Log log = new Log("Test");
		log = logDAO.persist(log);
		transaction.commit();
		assertNotNull(log.getId());
	}
}
